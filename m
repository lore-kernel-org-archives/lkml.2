Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946128Ab2EKRyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:54:13 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:34432 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946098Ab2EKRyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:54:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7S08pqsVM1mh3SzwlTK_I11LP6wzUceJoIC8ZdHHXx.9Sm7
 M.mXzNd1v0MbMuSoZ.ZyeTj0kKJCqFsLvYqLI2Ir9tt.NSiMYL5Uv7_yb2m1
 ySYxIeZu0p99g4mJxD855RoqPcsxR5b76DNA8TQzYMqe8gJlsX_.rUxMewq8
 ddtBN9hAArghQYfOJf_p.8bt.UDAZMJwSqd7O1oGwp10gH0Ft0lT4Kpc9hKV
 vi9D0Bc7eOz.TxXqBjT3nie4dmcvu4J6xAli7f0yAtHIrhfxO4R5VubaDlQ2
 2BMI0LX7C6vFMD9MhNitEUGpov3JFJy7tpypyKYN7crf_tj04TqP5Xy_tQoQ
 Q1kLV_dz2K3mp3EqfrIF9p2CWy2L6BNyIn2WLAtzGmewqs9KuIwk6npVTslF
 udc7wz8HBt9dV_MNjm4C0hVZsAHIc2w1V6L4-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 12:54:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 05/29] slab: rename gfpflags to allocflags
In-Reply-To: <1336758272-24284-6-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111253510.31049@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-6-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> A consistent name with slub saves us an acessor function.
> In both caches, this field represents the same thing. We would
> like to use it from the mem_cgroup code.

Acked-by: Christoph Lameter <cl@linux.com>
