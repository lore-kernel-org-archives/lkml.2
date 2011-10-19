Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1JSPez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:34:55 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20276 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754157Ab1JSPey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:34:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EG7e6YEVM1mdZd1vH.A2qL5XNwL1WAZ0iMRu3p7hCX2aVap
 EaUQVBjO3p5M_faLIDzOY4pVwIpv0XD9KOOO2D2O5o5.79L4dXExgRMdfsEe
 mfv8nSr_3ej3Lp94pu6ShfL5cSc_O7bpJzhyRk4pj.sFqog3O6zvTo0mMCh2
 VrQN_JcttG454Mjvdu6XLGVaLcZy71ElKtT.UQwCQV7dcbs1r_S2Fg4xeimK
 uKRjZ53sL813cSQbHg3q9qwhHFNs8cQAR4VykXkSg6w2E7ROS5tUQWvx05Q7
 qTzzN1jQLZRHRLzsU6EAZ5wm4wckY1pmkr6d.sCe.RR4reknBu5OhJJeIYIF
 gjVs_CpWX6FxKwBrPGxPns3UbKqngqUKnr8W9eZZiBvWlTTBzA4wHRh2rmIS
 yveJT73s5bDGOE0ZtJDt8ADBBP27GE5duhRTC
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 19 Oct 2011 10:34:49 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, avi@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, kaber@trash.net,
        a.p.zijlstra@chello.nl, kvm@vger.kernel.org, jeremy@xensource.com
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
In-Reply-To: <1319016218.23426.104.camel@debian>
Message-ID: <alpine.DEB.2.00.1110191033480.24001@router.home>
References: <1318237851.27949.190.camel@debian>  <alpine.DEB.2.00.1110101026080.16264@router.home>  <1318324774.27949.693.camel@debian>  <alpine.DEB.2.00.1110110910480.3388@router.home>  <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
  <alpine.DEB.2.00.1110120910540.26610@router.home>  <1318908091.23426.52.camel@debian>  <alpine.DEB.2.00.1110180932330.687@router.home> <1319016218.23426.104.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Alex,Shi wrote:

> Thanks for comments! I initialized the patch as following accordingly,
> And cc to more maintainers for review. I checked all code except xen/kvm
> part, totally a idiot for them.

Acked-by: Christoph Lameter <cl@gentwo.org>

