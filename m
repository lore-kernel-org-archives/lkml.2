Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab2AEU7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:59:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64001 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2AEU7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:59:40 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <20120105182149.GB24242@srcf.ucam.org>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-6-git-send-email-olof@lixom.net>
	<20120105182149.GB24242@srcf.ucam.org>
Date: Thu, 5 Jan 2012 12:59:39 -0800
Message-ID: <CAOesGMgs7VpnckyNC75NgCU9prVrUaYhFdrrLA=Cf+9A4OdHgg@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit efi/kernel
From: Olof Johansson <olof@lixom.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 10:21 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> This seems like a reasonable step, but outside some special cases it's
> not going to be terribly useful - general purpose EFI machines aren't
> going to boot unless you can set the boot variable, which requires
> runtime services. ChromeOS machines presumably have their own way of
> handling this so I've no objection to adding it if it helps them, but
> just wanted to make sure people knew that it's something that we'd still
> need to fix up if we want this to work elsewhere.

Thanks, good point. And yes, on ChromeOS there is a wrapper around the
kernel that provides the bootargs and a few other things, so we get by
with this limited EFI support there.

Given that the feature has been missing for years now, and it's a
nontrivial amount of work to get the mode switching implemented right
and debugged, I'm not inclined to go the whole way. This is a good
start, and if someone needs the rest of the functionality they can
build on top of this.


-Olof
