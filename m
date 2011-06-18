Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1FRPEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:04:44 -0400
Received: from mail-pv0-f180.google.com ([74.125.83.180]:61623 "EHLO
	mail-pv0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1FRPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:04:42 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jun 2011 11:04:42 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Jr11fNeRjdIH1hPB7TT768sRm0LE6iA0iAU4LNEMxbURxnXKBFOFHQpOwr89CBlj4N
         un507ChVzc1aZtnQsG61to8/lxpRGfm3s5Dmlc6Mubmc493QPDbT6LLFNKhjWnEjTy/k
         1HXqmkQZEv+J3z37Jra4b53S79wXsqTOHpoQQ=
Date: Sat, 18 Jun 2011 07:57:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tejun Heo <tj@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: Re: Re: [alsa-devel] [PATCH v4 11/18] input: Add initial support
 for TWL6040 vibrator
Message-ID: <20110618145724.GB18190@core.coreip.homeip.net>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <5740779.B2nyl9oMW4@barack>
 <20110617094332.GE2611@htj.dyndns.org>
 <1541792.uUz2bSMDMl@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1541792.uUz2bSMDMl@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 01:59:47PM +0300, Péter Ujfalusi wrote:
> On Friday 17 June 2011 11:43:32 Tejun Heo wrote:
> > Just use the default params
> > 
> > 	alloc_workqueue("twl6040-vibra", 0, 0);
> > 
> > Thanks.
> 
> I'll do this for the next posting
> 

Tejun,

For my education, what is the benefit of creating a dedicated workqueue
with alloc_workqueue (which, as far as I understand, does not end up
having dedicated worker threads but will use the common pool) and simply
queueing the jobs on system-wide workqueue?

Thanks.

-- 
Dmitry
