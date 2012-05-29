Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2E2Tz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:55:56 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28540 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754857Ab2E2Tzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:55:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KrHdEUkVM1mEDIvGbVuCYMimmqfI69bI6JyTSlb0uzR6Ofw
 VveIfS1_.62H0Imwxb4pCHgcQpkar2aVIzzZ2TrjnBn_3EmMfYIdnGVcFNoh
 l0pCHZgEjU5h1cArI8qsoXQk0ppmtivx3FBgCR15_X_0zOy1sALjJ2iKtu9o
 5NtOJmcbGr8DRGOLzng1.1ncTbRW4lr_xiQ2qZn84D5EWEoDZV_80Awn8R1V
 4LZJvjKn1TF.GBRvLf8ht9BaQ2VCbxX3_2fR_baGhCSCmh09X1XWo6AoUIZU
 _6kWvtwWptQcDC7tjS4IwlQXYpejQ.aklb4QzJj85SrBXnUb52.k1RKrPHKH
 vwfWYPhzI8D_hNZs4bvFkgoO801Eu72ge1ydpE068cP7mcU_Pf7lDvVFLwI2
 F
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 14:55:49 -0500 (CDT)
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
In-Reply-To: <4FC52612.5060006@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291454030.2504@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> I don't know about cpusets in details, but at least with NUMA, this is not an
> apple-to-apple comparison. a NUMA node is not meant to contain you. A
> container is, and that is why it is called a container.

Cpusets contains sets of nodes. A cpusets "contains" nodes. These sets are
associated with applications.

> NUMA just means what is the *best* node to put my memory.
> Now, if you actually say, through you syscalls "this is the node it should
> live in", then you have a constraint, that to the best of my knowledge is
> respected.

Eith cpusets it means that memory needs to come from an assigned set of
nodes.

> Now isolation here, is done in the container boundary. (cgroups, to be
> generic).

Yes and with cpusets it is done at the cpuset boundary. Very much the
same.
