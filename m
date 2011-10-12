Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab1JLOLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:11:14 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:28482 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750956Ab1JLOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:11:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: itxPw1AVM1mjkhuYLFRIuKGQIOrEdBK1xwT0m7p6Z.4YMI9
 4RN_Oa7m0ToR7IK2_4xokBBgVJlX3UpsJ7gkAuFXWHpPxd7Fpt8Eahlf9amo
 4rP5bM2tpF0mxCqcqQlEfQJDgXyZhlKgplY1dipb0WTMIxN4P0JTcBD0qdf4
 auBbkWfTPbRYm4I_GCMYGlOaXDEthEb.kUCaq7DaHyfiJNVoJvq4u4LLWE.a
 DbjhEzQLYtUzSeyN_fZgceWeOaeXWGXBMaD23wjBR7jhMlx5ZBT3bFzKu_5Z
 X6fFbCLDgenvBcOKT5FRdeJi.JTAJoif31ueddoreZFVZvrLdw4eNs3swfuA
 SmgrTb_xLYVRKTssm3XO3QUFxlkrovYB9t3VztOcgFYLNq30-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 12 Oct 2011 09:11:11 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
In-Reply-To: <1318428673.29699.13.camel@debian>
Message-ID: <alpine.DEB.2.00.1110120910540.26610@router.home>
References: <1318237851.27949.190.camel@debian>  <alpine.DEB.2.00.1110101026080.16264@router.home>  <1318324774.27949.693.camel@debian>  <alpine.DEB.2.00.1110110910480.3388@router.home>  <1318382964.27949.782.camel@debian>
 <1318428673.29699.13.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Alex,Shi wrote:

> I thought again of this_cpu_xxx function, yes, some of them are better
> to be replaced by __this_cpu__xxx if preemption is safe on the scenario.
> But this change is better to be done in another patch. I did not
> finished all changed function check today.  May try again in next week.
> What's you pinion of this?

I think its good to have it all in a single patch.

