Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2DQNYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:24:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40808 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175Ab2DQNYI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:24:08 -0400
X-Sasl-enc: fygnEFQe+FtsBGRd1vTuIpzB1/ZWTpesFnEmODfwA7Pn 1334669046
Date: Tue, 17 Apr 2012 14:24:04 +0100
From: James Le Cuirot <chewi@aura-online.co.uk>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: toshiba-acpi: =?UTF-8?B?UG9ydMOpZ8Op?= 3500 function keys
 broken since 2.6.33
Message-ID: <20120417142404.4499ca23@symphony.aura-online.co.uk>
In-Reply-To: <20120416203957.GC3959@thinkpad-t410>
References: <20120414224512.5f943f31@symphony.aura-online.co.uk>
	<20120416203957.GC3959@thinkpad-t410>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 15:39:57 -0500
Seth Forshee <seth.forshee@canonical.com> wrote:

> On Sat, Apr 14, 2012 at 10:45:12PM +0100, James Le Cuirot wrote:
> > Following a kernel git bisect, I have found that commit
> > 6335e4d56681f6f08f24f4b812a72d402793d393 broke the function keys on
> > the Toshiba Portégé 3500. Details of that commit can be seen at
> > https://lkml.org/lkml/2009/3/31/440.
> > 
> > Apart from fnfxd not responding to key presses, the hotkey_ready and
> > hotkey values found in /proc/acpi/toshiba/keys remain stuck on 0
> > whereas before they used to change after a single function key
> > press.
> > 
> > Some months after the commit, a patch was proposed in response to
> > fix the multimedia keys on the Toshiba Satellite A40. Unfortunately
> > this patch didn't fix the problem in my case. Regardless, the patch
> > can be found at https://lkml.org/lkml/2010/2/27/138.
> > 
> > Matthew Garrett initially requested an acpidump in order to diagnose
> > the above problem so I have attached mine here. I also attempted to
> > get the ACPI debug output but it more than filled my entire dmesg
> > buffer and I wasn't even sure it was relevant. Let me know if you
> > wish to see that anyway.
> > 
> > Please CC me in your replies.
> 
> I did some work on toshiba_acpi to support additional interfaces for
> supporting hotkeys that went into 3.4. Based on your ACPI tables this
> might help you, but I can't be certain, so you should give the latest
> 3.4-rc a try to see if it helps.

I tried 3.4-rc3 and after wrestling with a new, unrelated ACPI issue
that stopped the machine from booting at all (now reverted), I found
that the hotkeys still don't work. Shame, it sounded promising.

James
