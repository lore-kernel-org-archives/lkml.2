Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2EGTtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:49:47 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41018 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab2EGTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:49:45 -0400
Date: Mon, 7 May 2012 21:49:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC_ABI PATCH v13 01/26] amd64_edac: convert driver to use the
 new edac ABI
Message-ID: <20120507194933.GB8627@aftab.osrc.amd.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-2-git-send-email-mchehab@redhat.com>
 <20120507143143.GD11462@aftab.osrc.amd.com>
 <4FA7F468.8070101@redhat.com>
 <20120507161710.GF11462@aftab.osrc.amd.com>
 <4FA7FF6C.7020404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA7FF6C.7020404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:59:24PM -0300, Mauro Carvalho Chehab wrote:
> This change has nothing to do with "amd64_edac: convert driver to use the new edac ABI",
> but to the previous patch.
> 
> It is possible to merge it with the previous patch that made the changes
> at the edac_mc core, but that would require to re-review that patch, and will
> loose the history about this specific change.

That's fine - the change is simple enough to merge it in the respective patch.

> If all you want is to have this change applied before the amd64 patch, for you
> to better test it, I've re-based it on my experimental tree to be between
> the two patches:
> 	http://git.infradead.org/users/mchehab/edac.git/commitdiff/3f4610491cc58dda8c737378212559dce77adde2
> 
> Anyway, if you still prefer that I merge it with "edac: Change internal representation to work with layers"
> patch, I can do it.

Yes please, this way you have only the patchset and not the patchset + n
fixup patches at the end.

I'll continue reviewing/testing from the one before "amd64_edac: convert
driver to use the new edac ABI."

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
