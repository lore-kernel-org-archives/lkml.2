Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab2GRVFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:05:53 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38082 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2GRVFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:05:51 -0400
Date: Wed, 18 Jul 2012 23:05:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powernow-k8: Fixup missing _PSS objects message
Message-ID: <20120718210549.GA17504@aftab.osrc.amd.com>
References: <1342624043-29763-1-git-send-email-bp@amd64.org>
 <201207182150.51441.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207182150.51441.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 09:50:51PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 18, 2012, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > _PSS objects can also be missing if Cool'N'Quiet is disabled in the
> > BIOS. Add that to the FW_BUG message for the user to try before updating
> > her BIOS. Fix formatting while at it.
> > 
> > Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> I will take this, but it's kind of too late for v3.6.

Yeah, sure, whenever. I found it buried in my mbox since 3.2ish. And
since it is not urgent, you don't have to rush it for 3.6 but send it
upstream whenever you like.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
