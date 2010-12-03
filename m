Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0LCVDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:03:32 -0500
Received: from mx2.compro.net ([12.186.155.4]:63446 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0LCVDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:03:31 -0500
X-IronPort-AV: E=Sophos;i="4.59,295,1288584000"; 
   d="scan'208";a="6081243"
Message-ID: <4CF95B22.3010206@compro.net>
Date: Fri, 03 Dec 2010 16:03:30 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel tree "diff -urN" anomaly?
References: <4CF949AF.1000502@compro.net> <20101203204709.GA17591@merkur.ravnborg.org>
In-Reply-To: <20101203204709.GA17591@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 03:47 PM, Sam Ravnborg wrote:
> On Fri, Dec 03, 2010 at 02:49:03PM -0500, Mark Hounschell wrote:
>> I start with two clean identical 2.6.36.1 kernel trees (different names
>> of coarse). I build one of them. I then do a "make clean mrproper" in
>> the tree I built. Why then does the diff command in the subject line
>> find the following files changed?
>>
>> drivers/gpu/drm/radeon/evergreen_reg_safe.h
>> drivers/gpu/drm/radeon/r100_reg_safe.h
>> drivers/gpu/drm/radeon/r200_reg_safe.h
>> drivers/gpu/drm/radeon/r300_reg_safe.h
>> divers/gpu/drm/radeon/r420_reg_safe.h
>> drivers/gpu/drm/radeon/r600_reg_safe.h
>> drivers/gpu/drm/radeon/rn50_reg_safe.h
>> drivers/gpu/drm/radeon/rs600_reg_safe.h
>> drivers/gpu/drm/radeon/rv515_reg_safe.h
> 
> Files are generated during the build.
> So after you have build your kernel the files are present.
> And the Makefile is missing logic to delete the files during "make clean".
> 

OK, broken Makefile then

Thanks
Mark
