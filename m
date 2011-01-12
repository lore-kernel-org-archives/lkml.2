Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1ALSzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:55:31 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58385 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1ALSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:55:29 -0500
Date: Wed, 12 Jan 2011 13:55:24 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dave Martin <dave.martin@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>, Rabin Vincent <rabin@rab.in>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: relocation out of range (when loading a module)
In-Reply-To: <20110112184258.GH11039@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1101121350350.25498@xanadu.home>
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home> <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk> <4D2D1942.4050905@ahsoftware.de>
 <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com> <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Russell King - ARM Linux wrote:

> Then came along the embedded initrd/initramfs idea which rather buggered
> the scheme when large initramfs are embedded into the image.
> 
> As the overall feeling at the time was "don't use large initrds" it's
> something I've never really cared about - and I'm still of the opinion
> that 16MB of compressed initrd/initramfs is rather silly.

It is... but we have more than 32MB of RAM total now, and people are 
running standard distributions on ARM these days, such as Fedora or 
Ubuntu, including their corresponding initrd that may contain lots of 
modules, splashscreen data, etc.  So it might be a good idea to think 
about fixing this limitation before it comes back again.


Nicolas
