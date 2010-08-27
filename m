Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0H0Hk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:40:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58813 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0H0Hkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f/xNfEc3JOydFN0A+E1G5XALED7LZKXTlilV5iyzqPkRhKTasOO1WMpl0w46+cvde7
         PKsAe+tTmz8ufXJ+Xv6SmfNDKMlscVLVQ7aoQP+G6f1Dv0CtPrWu75GwB1NHJ59rvxzZ
         ALEOZ4Y+oIiV+ADGrgcVJJA/qT7pydg14Bo3s=
Date: Fri, 27 Aug 2010 00:40:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the drivers-x86 tree
Message-ID: <20100827074048.GB9120@core.coreip.homeip.net>
References: <20100827115950.dd942b90.sfr@canb.auug.org.au>
 <20100827025148.GA25469@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827025148.GA25469@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 03:51:48AM +0100, Matthew Garrett wrote:
> On Fri, Aug 27, 2010 at 11:59:50AM +1000, Stephen Rothwell wrote:
> 
> > After merging the drivers-x86 tree, today's linux-next build (powerpc
> > ppc64_defconfig and x86_64 allmodconfig) produced this warning:
> 
> Oh Lordy. I should stop merging anything that contains "select". I'll 
> take a look at this tomorrow, but I'm about to head away for a week - if 
> anyone has a fix, feel free to find a way to get it merged.
> 
> (Dmitry, there was a Kconfig issue when I merged your patch, so it's 
> entirely plausible that you're a completely innocent bystander here)

Yeah, I think I am innocent here. My patch was adding "select
INPUT_SPARCEKMAP" which is a library module and which I ensure to be
selectable as long as INPUT is enabled. I do not want to switch it
around into "depends on" since it is implementation detail and user
should not care.

Thanks.

-- 
Dmitry
