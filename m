Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab1JNTVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:21:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38025 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab1JNTVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:21:18 -0400
Date: Fri, 14 Oct 2011 20:20:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Message-ID: <20111014192057.GT21648@n2100.arm.linux.org.uk>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <201110141729.41515.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com> <201110141827.53906.arnd@arndb.de> <alpine.LFD.2.02.1110141353390.17040@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110141353390.17040@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 02:01:07PM -0400, Nicolas Pitre wrote:
> The way I'm restructuring things around this is that AUTO_ZRELADDR will 
> always be active by default, just like ARM_PATCH_PHYS_VIRT now.  This 
> platform specific exclusion thinking is a step backward so I'd prefer if 
> people would refrain from going there for the moment.

Are you expecting everyone to change the way they load the zImage
overnight then?
