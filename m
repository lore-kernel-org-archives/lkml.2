Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2FSNyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:54:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2FSNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FE09AFC020000780008A9DC@nat28.tlf.novell.com>
References: <4FE09AFC020000780008A9DC@nat28.tlf.novell.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 19 Jun 2012 15:53:53 +0200
Message-ID: <CAPXgP13y_xOUzHdStsDWescPtJYn0nvMhsQ7c2XS3HBuE=jwow@mail.gmail.com>
Subject: Re: printk behavioral regression
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 3:30 PM, Jan Beulich <JBeulich@suse.com> wrote:
> running 3.5-rc3 on a SLE11 SP1 system, early boot messages (apart
> from the very first one) end up in /var/log/messages rather than
> /var/log/boot.msg. I didn't dig deep enough yet to figure out what
> is causing this, and would hope that you (having contributed most
> of the changes between 3.4 and 3.5-rc3) might have an idea.

Hmm, no idea really, and why this should change.

/var/log/boot.msg is a SUSE speciality, that, as far as I know, just
dumps 'dmesg' after bootup, it has not much to do with the normal
syslog/klog logging in /var/log/messages, where all your messages should always
end up, and what seems to work for you.

Kay
