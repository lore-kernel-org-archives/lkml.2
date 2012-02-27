Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2B0J2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:28:55 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:55319 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2B0J2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:28:54 -0500
Date: Mon, 27 Feb 2012 10:28:38 +0100
From: Borislav Petkov <bp@amd64.org>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH linux-next] edac: move const pci_device_id tables from
 __devinitdata to __devinitconst.
Message-ID: <20120227092838.GB3970@aftab>
References: <83869.69195.bm@smtp156.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83869.69195.bm@smtp156.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 08:05:30AM +0100, Lionel Debroux wrote:
> Based on PaX and earlier work by Andi Kleen.
> 
> Patch against linux-next (20120224).
> 
> ---
> 
> From e4ed493cf2241f6ba880459e48674de0b2a394a3 Mon Sep 17 00:00:00 2001
> From: Lionel Debroux <lionel_debroux@yahoo.fr>
> Date: Mon, 27 Feb 2012 07:41:47 +0100
> Subject: edac: move const pci_device_id tables from __devinitdata to
>  __devinitconst.
> 
> These const tables are currently marked __devinitdata, but Documentation/PCI/pci.txt says:
> "
> o The ID table array should be marked __devinitconst; this is done
>   automatically if the table is declared with DEFINE_PCI_DEVICE_TABLE().
> "
> So use DEFINE_PCI_DEVICE_TABLE(x).
> 
> Based on PaX and earlier work by Andi Kleen.
> 
> Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>

Applied [with minor commit msg formatting changes], thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
