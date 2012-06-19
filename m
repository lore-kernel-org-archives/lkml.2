Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2FSODt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:03:49 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38305 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2FSODs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Tue, 19 Jun 2012 10:03:48 -0400
Message-Id: <4FE0A30C020000780008AA0B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 19 Jun 2012 15:04:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kay Sievers" <kay@vrfy.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: printk behavioral regression
References: <4FE09AFC020000780008A9DC@nat28.tlf.novell.com>
 <CAPXgP13y_xOUzHdStsDWescPtJYn0nvMhsQ7c2XS3HBuE=jwow@mail.gmail.com>
In-Reply-To: <CAPXgP13y_xOUzHdStsDWescPtJYn0nvMhsQ7c2XS3HBuE=jwow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.06.12 at 15:53, Kay Sievers <kay@vrfy.org> wrote:
> On Tue, Jun 19, 2012 at 3:30 PM, Jan Beulich <JBeulich@suse.com> wrote:
>> running 3.5-rc3 on a SLE11 SP1 system, early boot messages (apart
>> from the very first one) end up in /var/log/messages rather than
>> /var/log/boot.msg. I didn't dig deep enough yet to figure out what
>> is causing this, and would hope that you (having contributed most
>> of the changes between 3.4 and 3.5-rc3) might have an idea.
> 
> Hmm, no idea really, and why this should change.

Okay, then I'll indeed need to do some debugging.

> /var/log/boot.msg is a SUSE speciality, that, as far as I know, just
> dumps 'dmesg' after bootup, it has not much to do with the normal
> syslog/klog logging in /var/log/messages, where all your messages should 
> always end up, and what seems to work for you.

No, boot messages (at least by default) end up _only_ in
/var/log/boot.msg, and thus significantly help keeping the size
of /var/log/messages down. SUSE specialty or not, there
clearly is some user space visible change here.

Jan

