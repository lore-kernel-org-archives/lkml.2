Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2B1APD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:15:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49132 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2B1APB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:15:01 -0500
Message-ID: <4F4C1C7B.7020401@zytor.com>
Date: Mon, 27 Feb 2012 16:14:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: linux-kernel@vger.kernel.org, Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
In-Reply-To: <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Do you mind querying the state in Grub? This will mean that we'll have
> to remove the code that sets this bit from the kernel and leave it the
> in the state reported by the grub?
> 

Doing anything in Grub is idiotic at best.  The place to do it is in the
kernel BIOS stub code.

> If so I'm not sure about it. We check the BIOS data area as defined
> for IBM PCs (1981), so a fair amount of user should benefit from the
> change. Those non-BIOS boots can set the numlock=0 and won't be
> affected by this. I think this isa lot easier to implement than doing
> it in the BIOS bootstrap code.

Not really, and your patch really shows it.  It probably could be done
in less than 20 lines, total.

	-hpa



