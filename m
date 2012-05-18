Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966304Ab2ERRx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:53:56 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41756 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965964Ab2ERRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:53:54 -0400
Date: Fri, 18 May 2012 19:53:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC v26 00/66] EDAC patches for v3.5
Message-ID: <20120518175336.GB20215@aftab.osrc.amd.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
 <20120518164615.GY20215@aftab.osrc.amd.com>
 <4FB68A28.9090205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB68A28.9090205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 02:43:04PM -0300, Mauro Carvalho Chehab wrote:
> >>   RAS: Add a tracepoint for reporting memory controller events
> > 
> > Are you kidding me?
> > 
> > You want to send patches upstream which are still in review and 
>
> No, I want to post the last version of the patches and provide a
> clearer description of what this patch series do, before sending the
> git pull request when the merge window opens.

I'm fine with offloading some of your stuff which has been reviewed
and agreed upon but pushing in stuff into the merge window (it should
open over the weekend, my clairvoyant skills tell me) which is still in
review is a no-no.

You also know about the linux-next rule, right? Now you can't tell me
your patches have been for a couple of weeks in linux-next because
you're constantly rebasing them.

So pls drop the act and adhere to the rules like everyone else.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
