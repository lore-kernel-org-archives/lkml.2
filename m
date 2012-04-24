Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2DXKqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:46:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43034 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2DXKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:46:11 -0400
Date: Tue, 24 Apr 2012 12:46:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac.h: Add generic layers for describing a memory
 location
Message-ID: <20120424104606.GB11559@aftab.osrc.amd.com>
References: <4F95A5CE.7010804@redhat.com>
 <1335208746-15223-1-git-send-email-mchehab@redhat.com>
 <4F95B671.2070003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F95B671.2070003@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 08:07:13PM +0000, Mauro Carvalho Chehab wrote:
> There are 55 patches affected by this change. Applying them locally
> was as simple as running this small script to the submitted patches:
> 
> $ for i in `quilt series`; do sed s,is_csrow,is_virt_csrow,g $i|sed s,GET_POS,EDAC_DIMM_PTR,g| >a && mv a $i; done
> 
> However, mailbombing 55 patches just because of the above rename
> is probably not very welcome by the people at the ML. Also, at least
> for me, it seems more logical to add a patch like that at the end of
> the patch series, than to force people to re-analyze the entire patchset.
> 
> Due to that, I won't resend the entire patchbomb to the ML.

This is exactly one of the reasons why one shouldn't send mailbombs like
that in the first place.

Documentation/SubmittingPatches does not state this for no reason:

"If you cannot condense your patch set into a smaller set of patches,
then only post say 15 or so at a time and wait for review and
integration."

And having patches which change earlier patches in your patchset is
absolutely a no-no.

This means at least that your previous patches haven't been reviewed
properly and still suffer some churn, causing the later ones to need
readjustment.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
