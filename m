Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946024Ab2EKRvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:51:19 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:30888 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945970Ab2EKRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:51:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TZT0ymYVM1lVAQvXIgjR3thQhN9bxVt95MzbWXqNuEZGIOZ
 QSOqfbZMlcLIdnadAZ5Ml1SNcfiONhn9er0MI9f9gYIV2RLCfkBqpP9BfPGy
 mdv6rhWnfefBeYV_nW1vd2JHq_tKgfkdNw8zCz7ocHPOXsYwrMwU45LDNury
 3.0z5CjMrjPMG5nZj8MHDOwsN8kYGW7zXbgekLNWlIPMAULxwQN3UR4bF_AI
 PHdrGvxu95VThfAp5gIp36HXIQsb3P.bw4LwHJ0DB6epYX2MtljdWltJgF.K
 nXaWwQECmStzTZRypMpLZbyjtId8kW2U1SKE2u1wbR_gix_RsXdankpFCXwj
 o66XqpNA.cTfqxJ8fntTbBSy9uirjjmunqnwzgVBkxH_jEDsTIydvGPDYRE.
 wuBdmNJewkUagM5fefokn4h_93g--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 12:51:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 02/29] slub: fix slab_state for slub
In-Reply-To: <1336758272-24284-3-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111250590.31049@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-3-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Lameter <cl@linux.com>

