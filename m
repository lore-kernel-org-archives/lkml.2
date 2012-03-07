Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab2CGVds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:33:48 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59154 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2CGVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:33:46 -0500
Date: Wed, 7 Mar 2012 22:33:24 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Improve the comments to better describe the memory
 concepts
Message-ID: <20120307213324.GC29373@aftab>
References: <1331120224-27420-1-git-send-email-mchehab@redhat.com>
 <20120307142411.GA26789@aftab>
 <4F578B70.9080903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F578B70.9080903@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:23:12PM -0300, Mauro Carvalho Chehab wrote:
> 
> Boris,
> 
> Thanks for reviewing it! Comments and a reviewed version below.

Looks good.

[..]

> [PATCHv2] edac: Improve the comments to better describe the memory concepts
> 
> The Computer memory terminology has changed with time since EDAC was 
> originally written: new concepts were introduced, and some things have 
> different meanings, depending on the memory architecture.
> 
> Improve the definition of all related terms.
> 
> Also, describe each memory type in a more detailed fashion.
> 
> No functional changes. Just comments were touched.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>


Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
