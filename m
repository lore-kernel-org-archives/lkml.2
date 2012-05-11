Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab2EKS4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:56:45 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:35714 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756777Ab2EKS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:56:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ANP0zRQVM1npFnPICluuK.xFTLbavsvzJp3Nzb5BG9wKri5
 A0L0nU5PDxo_ejWzi3OUoZCCH1FjrOY4qy51.7KoOd8Z4ZSfmUs8Rzii0Hny
 5dispEIYzyvv2lvFhWamQqYZa5BL3GB8SSATL0O2BHBgjCxREUofsI3O6Vh9
 gn7n7hNCgDXARaRl1Lgufs_ZPJvIYFOIbLgCmoS_HDNa3ApjIwXziyIMF4T7
 mFgIFcNy1I61rYVdbTbTDRv7jm0Op26JTmcv7SH340TYMoADEF._nfOaYnQd
 Dw8MTODsR7YKjGIEgykuopUamgQzYbt7vAeJa1SvfUbUBnxWVoS.2PQ3m7XY
 Z442Y9VFxH_fhbIStcnCnCjCljsL8bkSpNf4WKSaLh3pd9c2IFLKBBhMQ3Es
 C
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 13:56:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
In-Reply-To: <4FAD5DA2.70803@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111354540.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
 <4FAD566C.3000804@parallels.com> <alpine.DEB.2.00.1205111316540.386@router.home> <4FAD585A.4070007@parallels.com> <alpine.DEB.2.00.1205111331010.386@router.home> <4FAD5DA2.70803@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> So we don't mix pages from multiple memcgs in the same cache - we believe that
> would be too confusing.

Well subsystem create caches and other things that are shared between
multiple processes. How can you track that?

> /proc/slabinfo reflects this information, by listing the memcg-specific slabs.

What about /sys/kernel/slab/*?


