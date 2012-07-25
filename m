Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2GYSdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:33:25 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:43652 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752493Ab2GYSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:33:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XNiodLgVM1nOx_VbFl2n54w.I1Fajiw5OaVIKcH55LP8c85
 im2KrHro82y150vs..iz7xNBzd3RBC.GIDyRMn2EYNNqdIA5FLwnP6a24j5n
 lwuMNkNpwZ16xxmZQupK1S_HddjsmzZrWh3B8Cwk4SxUov_Ei5a.jq4AQK7c
 XLyGpyab8LH3cDRTaZIi_wqanJ8DNRVTYgeldsJlTcO9sNLgdsAuLRiUmHX6
 z30x4WrfHrEXE6iiVam8U9q4ODGgKzXZXzqYQZhfnY.tYhQIJwynA8qdBcN5
 hwZSPoPUnla4KWI5c4hTAGaPtbwaEJcyfrh92PMZOyAY1w72UNOvpMRmY61t
 SWUjIf4NpJRdQ_q.dxRosIGEchW1CnuDcQtVY1ME0QiINty8eBYL21Upu5dF
 4h13gBVrJBIVpCBhd
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 13:33:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        cgroups@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 05/10] slab: allow enable_cpu_cache to use preset values
 for its tunables
In-Reply-To: <501039F9.7040309@parallels.com>
Message-ID: <alpine.DEB.2.00.1207251331480.4995@router.home>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1207251204450.3543@router.home> <501039F9.7040309@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Glauber Costa wrote:

> It is certainly not through does the same method as SLAB, right ?
> Writing to /proc/slabinfo gives me an I/O error
> I assume it is something through sysfs, but schiming through the code
> now, I can't find any per-cache tunables. Would you mind pointing me to
> them?

The slab attributes in /sys/kernel/slab/<slabname>/<attr> can be modified
for some values. I think that could be the default method for the future
since it allows easy addition of new tunables as needed.

