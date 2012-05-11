Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab2EKSc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:32:56 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:30190 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933159Ab2EKScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:32:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IvxqZzUVM1kH8q3DPVBcRdECJhKLpnCPBfZ3UyrXi.AqnnX
 LKg5n8RJCWTumeDxvYXxcglLFblAV.5WbyNujEuvK0hohzFWeiTq6nneBUVV
 Ue.HMxPesWIU26tGdjzWgO64_PUJlZV7ZC8_EhICWlA0cWNvQ4OyZFIbAmzC
 92L2VETQZ7LMAsASREER93YzeYK7kaRjlFkStZk5_mPLsODoycVH63OFC.21
 mVqVS0lea1miDPNyKALr3w6__GsTcD18TwerqEz6HmaAtSqEZP_.ENq8_1FY
 iIpAbfdy7h7BoujPGp4xqFiEythHYTGAOQFhuVMgbKiwb_L4ny5I1uup1fwz
 dXsYndtJ.I.rKPvw4nyUef8vbokXuZYQpmjm1X8J_CrtK5GP04ZV2MKtnejr
 d
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 13:32:48 -0500 (CDT)
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
In-Reply-To: <4FAD585A.4070007@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111331010.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
 <4FAD566C.3000804@parallels.com> <alpine.DEB.2.00.1205111316540.386@router.home> <4FAD585A.4070007@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> Thank you in advance for your time reviewing this!

Where do I find the rationale for all of this? Trouble is that pages can
contain multiple objects f.e. so accounting of pages to groups is a bit fuzzy.
I have not followed memcg too much since it is not relevant (actual
it is potentially significantly harmful given the performance
impact) to the work loads that I am using.

