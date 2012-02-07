Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2BGPMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:12:53 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:29192 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751564Ab2BGPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:12:51 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MPJyFBAVM1mdLx.okoAGuTcMwca1MgE0dtWTskccjZZBUO4
 fuJxCrN8s6ufqDtdXIt14qpr88pbtT0oaGKBsBjTiwHKeoH39VO_rHDMB5LU
 uRJHBkwGejqatp6TMMmxbe9pXvHyY08ewHnILEg1TaVLHKjH5dqAPPBVMHff
 .x5KGqISyqZxosindeZAwRAKYY_tV_wE.O7NFOMonv0G57BpL3j.V.Fa8Rhe
 Jvr3jlGZrh8meWHx6_8vCnew38ruBbcGXHEgrHeWLlpXIG6MelSUdkY2oTWs
 QvjFhJEQm1SZr6oF2ly8I9EjhY6Q547O2bKCg6L_.Ou60bWyE3K_.ZPsa5LX
 fy8S4_fRAkkAfv.uXBJdsWA591dEdDx36hQJ5ntiyldPR5eJ6myN9jSWpy2J
 9
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 7 Feb 2012 09:12:48 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [rfc PATCH]slub: per cpu partial statistics change
In-Reply-To: <1328591165.12669.168.camel@debian>
Message-ID: <alpine.DEB.2.00.1202070910320.29500@router.home>
References: <1328256695.12669.24.camel@debian>  <alpine.DEB.2.00.1202030920060.2420@router.home>  <4F2C824E.8080501@intel.com>  <alpine.DEB.2.00.1202060858510.393@router.home> <1328591165.12669.168.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1382060301-1328627569=:29500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1382060301-1328627569=:29500
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 7 Feb 2012, Alex,Shi wrote:

> Yes, I want to account the unfreeze_partials=EF=BC=88=EF=BC=89 actions in
> put_cpu_partial=EF=BC=88). The unfreezing accounting isn't conflict or re=
peat
> with the cpu_partial_free accounting, since they are different actions
> for the PCP.

Well what is happening here is that the whole per cpu partial list is
moved back to the per node partial list.

CPU_PARTIAL_DRAIN_TO_NODE_PARTIAL ?

A bit long I think. CPU_PARTIAL_DRAIN?

UNFREEZE does not truly reflect what is going on here.

---1463811839-1382060301-1328627569=:29500--
