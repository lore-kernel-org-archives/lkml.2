Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2D3LPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:15:16 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39762 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab2D3LPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:15:14 -0400
Date: Mon, 30 Apr 2012 13:15:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Joe Perches <joe@perches.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120430111506.GE9303@aftab.osrc.amd.com>
References: <1335535895.25521.7.camel@joe2Laptop>
 <4F9AC44A.5000509@redhat.com>
 <20120428085223.GB26065@aftab.osrc.amd.com>
 <4F9D4F6E.4070106@redhat.com>
 <4F9D5A2E.2030506@redhat.com>
 <4F9D6A39.6040209@redhat.com>
 <1335717794.12022.19.camel@joe2Laptop>
 <4F9D7CB8.4000903@redhat.com>
 <20120430074717.GB8182@aftab.osrc.amd.com>
 <4F9E72E0.300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9E72E0.300@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:09:20AM -0300, Mauro Carvalho Chehab wrote:
> > you guys are so trigger-happy to apply humongous, cleanup patches but
> > let me ask this: can anyone of you really test those changes with each
> > driver? Do you have all the hardware that those patches touch?
> 
> Well, then why you've touched that in the first place, without even looking
> what would be affected at the EDAC core and at the drivers? Didn't you tested
> it on all hardware that your patch affected?

Because I simply missed that fact, which is my bad, sorry.

> This patch touches only on debug code that aren't even enabled on
> production kernels. Assuming that a sneaky bug were introduced, this
> won't cause much hurt, and any developer inspecting those debug
> messages will be able to discover and fix what happened there.

Ok, fine, I still will review the amd64_edac side of the changes.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
