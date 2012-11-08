Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2KHTIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:08:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48360 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2KHTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:08:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121108140649.GD19533@arwen.pp.htv.fi>
References: <50929233.7030609@gmail.com> <50967BFD.6000308@gmail.com>
 <20121106112751.GD11931@arwen.pp.htv.fi> <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
 <20121108140649.GD19533@arwen.pp.htv.fi>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Thu, 8 Nov 2012 20:07:57 +0100
X-Google-Sender-Auth: EjWzuQ1nHTGKDChi1SgMPlFbm64
Message-ID: <CAOUdcc_9UTZpdu6k7wyQc9Hjmv-0YgAGiwsm+NysEmS9VUxu+w@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 3:06 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> (please, never top-post)
>
got it!

> On Wed, Nov 07, 2012 at 02:14:00PM +0100, Dmytro Milinevskyy wrote:
>> Unfortunately I have some issues with git send-email.
>> I've attached the patch itself ..
>
> I'll apply it like that this time, but try to figure out how to send
> patches properly. We have some very helpful hints on
> Documentation/email-clients.txt which are hugely underused ;-)
>
well, I try to follow the rules as much as possible as long as tools work ... =)

regards,
-- dmytro

> --
> balbi
