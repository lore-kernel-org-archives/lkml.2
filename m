Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2KMUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:09:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35317 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:09:27 -0500
Date: Tue, 13 Nov 2012 16:09:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <gregkh@linuxfoundation.org>, <b-cousson@ti.com>,
        <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ndec13@gmail.com>
Subject: Re: [PATCHv2 0/5] staging: omap-thermal fixes
Message-ID: <20121113200902.GA22185@besouro>
Reply-To: <eduardo.valentin@ti.com>
References: <1352830204-21546-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1352830204-21546-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 13, 2012 at 02:09:59PM -0400, Eduardo Valentin wrote:
> Hello again Greg,
> 
> So here is the correct set of changes. They now include the
> right version of the patches and with the fixes reported
> by Enric. Thanks Enric for the heads up.
> 
> So, Several compilation fixes and a couple of debugging prints
> added to the omap-thermal driver under staging area.
> 
> Patches are also available here:
> 
> git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes_3.7

For those interested pulling using http:
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes_3.7

> 
> 
> Cheers,
> 
> Eduardo Valentin (4):
>   staging: omap-thermal: fix compilation
>   staging: omap-thermal: remove platform data nomenclature
>   staging: omap-thermal: remove freq_clip table
>   staging: omap-thermal: add IRQ debugging messaging
> 
> Radhesh Fadnis (1):
>   staging: omap-thermal: fix context restore function
> 
>  drivers/staging/omap-thermal/omap-bandgap.c        |   63 ++++++++----------
>  drivers/staging/omap-thermal/omap-bandgap.h        |    9 ---
>  drivers/staging/omap-thermal/omap-thermal-common.c |   69 ++------------------
>  3 files changed, 33 insertions(+), 108 deletions(-)
> 
> -- 
> 1.7.7.1.488.ge8e1c
> 
