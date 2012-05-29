Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2E2RZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:25:20 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:43961 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754088Ab2E2RZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:25:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: krBrtQ4VM1k333sFklkuiQtgL3In3ygfHfMhqwpQ3CMfvVl
 huymnCBahm2tsLwndNu8EkLOmbEGRfg8B80Brh8PJsHGiTAb3J50BDfFHk17
 _.sZ1PGCsh7lYJs3K5Wf154sA_ipsvLkyz2ZQzPdKR1RdEI3BwF9AbktcL_O
 M1iXUGRK2dDx18gfHwRvijPOGGADATYqWdhqhf3B4iWGHg.XVcTv3gXRlqNJ
 jU72Iwcr3f5p4gOPxS2RLharKtOsocP3XioYiL9rqIzNDsFQI8gjFngCsIN7
 BwXZdf8lVLF.jc6dTZDFVrA_XkL6DehN0WrXdDtOSVThXtN4EaKxOfwOlyu1
 iiF2OGsoerajQLNByzy0_kRTSvclonFrrMRph0crSAUFRsqkXERs6EOTOTrD
 w8z_.po1od_ia209WLp_AyFE.8egrqlvA82Dc
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 12:25:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
In-Reply-To: <4FC501E9.60607@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291222360.8495@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> I will try to at least have the page accounting done in a consistent way. How
> about that?

Ok. What do you mean by "consistent"? Since objects and pages can be used
in a shared way and since accounting in many areas of the kernel is
intentional fuzzy to avoid performance issues there is not that much of a
requirement for accuracy. We have problems even just defining what the
exact set of pages belonging to a task/process is.

