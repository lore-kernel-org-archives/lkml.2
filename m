Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2DROoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:44:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39014 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2DROoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120418103334.GD2232@pengutronix.de>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
	<20120229183436.GA30545@pengutronix.de>
	<20120417142105.GA21802@pengutronix.de>
	<94F013E7935FF44C83EBE7784D62AD3F092D1DC7@039-SN2MPN1-022.039d.mgd.msft.net>
	<20120418103334.GD2232@pengutronix.de>
Date: Wed, 18 Apr 2012 22:44:16 +0800
X-Google-Sender-Auth: iU5UYadwT3fBoAItkQhmWI6xB7g
Message-ID: <CADRPPNQRLyZK-zjeLUYCZtLe+8HhFzFALCMyPeaCGX+buaf+ug@mail.gmail.com>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep sleep
From: Li Yang <leoli@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Li Yang-R58472 <r58472@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 6:33 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi,
>
>> We certainly don't want the policy to be against the common practice
>> of the community.  If it is we can consider changing our policy.
>
> Nice, thanks for being open to discussion!
>
>> However I can't find a clear message stating the consensus of what the
>> Linux kernel community think of adding copyright claims.  I even found
>
> Well, what I know, the consensus is "common sense". What is obviously
> not "clear" in a way you could write it down. At least, Ben agrees.
>

We do honor your point and can be flexible on this.  I'm just not sure
if our policy need to be changed to align with the common sense of the
community.

>> some message that encourage adding copyright to maintain the GPL
>> license.
>
> I am interested. Do you have a link?

Well.  I can't find the exact message.  I remember it is from an email
discussion in which someone said by encouraging contributors to add
copyright claims to a file it would be clear that no one can change
the license of the file away from GPL.

- Leo
