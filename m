Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1BWC4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:56:04 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42880 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1BWC4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:56:03 -0500
Date: Tue, 22 Feb 2011 21:55:25 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 7/7] dt: add documentation of ARM dt boot interface
In-Reply-To: <20110223022239.18318.87333.stgit@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102222149370.22028@xanadu.home>
References: <20110223021524.18318.71902.stgit@localhost6.localdomain6> <20110223022239.18318.87333.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Grant Likely wrote:

> +The boot loader must load a device tree image (dtb) into system ram
> +at a 64bit aligned address and initialize it with the boot data.
[...]
> +                r2 : physical pointer to the device-tree block
> +                (defined in chapter II) in RAM.  Device tree can be located
> +                anywhere in system RAM, but it should be aligned on a 32 bit
> +                boundary.

So... which one is true?


Nicolas
