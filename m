Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2GYRHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:07:08 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:23441 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756446Ab2GYRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:07:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YNw0cx4VM1nVDwB01po6BtyKmmzp1NRh5eWSHbytc27Q.VI
 NivJowx5Q.Bozh.J0pPTaK2r7oapAurib8_eUASQpR.3ifpDVQtx7LFPS7ws
 4epFsZqPQ5o1y4qGQ8NBlezX0Pa8TonIKgKGohqrJWl8WTP29T1suO.9McXT
 bc9xNuOu_f2JLovQpPRgcwM3An.KxBGaaOWQ5cMaTEeKvpsY2fjgdFRJ9x4Y
 2vaRONn4D8kIW.zwcoVrgcqhmz2MDLP.Yn.uZxbHRcKzJ5u5wDX7ecVeOZh9
 k_ec8gJ.4L3aRM.1K9eicDBR8Ob4We3KKhoPiyfSvSCfknd2I3kTGHIaVUBf
 39V9ok8r0hkTK5WgJPtr9d7QZUBm5_S9GAfXmOyTerDgldR6Cl4qa_xOXue4
 Akl8ZyRp2p23SeZL40B6oPNdWCfuEo4pW9fvl3ShOyGC5GpVhUhM-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 12:07:00 -0500 (CDT)
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
Subject: Re: [PATCH 09/10] slab: slab-specific propagation changes.
In-Reply-To: <1343227101-14217-10-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1207251206300.3543@router.home>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-10-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Glauber Costa wrote:

> When a parent cache does tune_cpucache, we need to propagate that to the
> children as well. For that, we unfortunately need to tap into the slab core.

Slub also has tunables.

