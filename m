Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2E2OxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:53:06 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:40503 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753859Ab2E2OxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:53:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3zAj0SsVM1nq6IuQT2LBdCmemdzdMlQWxVMgvabIC_y4cdm
 c3YN.3SmwJ1_b3CdNSk5B3D.y.wkFYSSId24eavI._jM.3325rB9JwiizWTl
 jVpX7ZLUqp1J3TX9yjT8syk6K9pJk1Q2DVTgzaMNfH.3r0CabqD2O3Z.HF46
 r0_W.bzh03fdNEDxaT2oWsrMBSAfsdtZX8l4Mvo7uPu_TgNpzJCcepMExwGh
 ysPsgyDZj3n39H1zVtdv.TTZ7e5mTiPhN1RkUfSotycWuMqcNc8RQCK2nigX
 OlZ9SoAp5HAy9O3rFQbRHK7H12qC2CoQsEA9ka.Ue1j_SC0dYrhdKO3szxFd
 3ZVXyR9tUV0gX67FSYqbuUuJFzWtxKqCcZ2fSf_qr1aer9_UNJsdIE8vqmYs
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:52:59 -0500 (CDT)
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
Subject: Re: [PATCH v3 19/28] slab: per-memcg accounting of slab caches
In-Reply-To: <1337951028-3427-20-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290951520.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-20-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Glauber Costa wrote:

> This patch charges allocation of a slab object to a particular
> memcg.

Ok so a requirement is to support tracking of individual slab
objects to cgroups? That is going to be quite expensive since it will
touch the hotpaths.


