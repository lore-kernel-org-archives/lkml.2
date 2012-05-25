Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2EYPGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:06:01 -0400
Received: from mga07.intel.com ([143.182.124.22]:15443 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752246Ab2EYPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1205251636080.27303@math.ut.ee>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
	<20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
	<1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
	<alpine.SOC.1.00.1205251636080.27303@math.ut.ee>
Date: Fri, 25 May 2012 08:05:56 -0700
Message-ID: <CABE8wwtCj+QxZDxtN+bWaCHukivMOBG06i3qxVmVC5_K_Bbx9Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
From: Dan Williams <dan.j.williams@intel.com>
To: mroos@linux.ee
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 6:40 AM,  <mroos@linux.ee> wrote:
> I applied these 4 patches on top of todays git (one trivial conflict
> with include removal) and it does not work - hangs here:

Ok, I'll take a look.

Thanks for the help!

--
Dan
