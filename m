Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066Ab1IKLlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 07:41:35 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41276 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754298Ab1IKLld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 07:41:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1kRxDoAVM1nP85VAMLi740IsrNGcXlvVWlpnG5.L9j1cQvo
 bYIwFSUNqUfYu0qudKwmA0jhsuwRBauEhXS4MVKveMAG8pB_hR_ttTs.SAXq
 1s0aYkGCcDAp9wIr1dPvvwtzx4lQ9rlqIrTUkiLx5fzr3goJV5kOxUMGBoLl
 uO3PfpIzwZWKwW7tE0dpStwyu0EDm0IRDI9w68ZJvPpDQjJciC8nlZEmeFac
 NbqpN6Lp_rsIbP7T.pm3u85BjkzTOd3HHfbdqOwqdCsoSolY10X57NVRMK61
 xovL7hxsODHrjYxCDHUECYhir8mDJL1KxNt0R2A.f_u9TXaFMUV9jb2NSBVi
 Hf5v_pvf0CJVnEvOwAJt_Pwbxp4d9Aoz5vjdMRV4OHN.jvDLiTAwfzoI7UWA
 ThljDV.u8chC2UpTtq.6WYw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Sun, 11 Sep 2011 06:41:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] slub Discard slab page only when node partials > minimum
 setting
In-Reply-To: <1315557944.31737.782.camel@debian>
Message-ID: <alpine.DEB.2.00.1109110640240.5059@router.home>
References: <1315188460.31737.5.camel@debian>  <alpine.DEB.2.00.1109061914440.18646@router.home>  <1315357399.31737.49.camel@debian>  <alpine.DEB.2.00.1109062022100.20474@router.home>  <4E671E5C.7010405@cs.helsinki.fi> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1109071003240.9406@router.home>  <1315442639.31737.224.camel@debian>  <alpine.DEB.2.00.1109081336320.14787@router.home> <1315557944.31737.782.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Sep 2011, Alex,Shi wrote:

> On Fri, 2011-09-09 at 02:37 +0800, Christoph Lameter wrote:
> > On Thu, 8 Sep 2011, Alex,Shi wrote:
> >
> > > BTW, some testing results for your PCP SLUB:
> > >
> > > for hackbench process testing:
> > > on WSM-EP, inc ~60%, NHM-EP inc ~25%
> > > on NHM-EX, inc ~200%, core2-EP, inc ~250%.
> > > on Tigerton-EX, inc 1900%, :)
> >
> > There is no minus on tigerton. I hope that is not a regression?
>
> Sorry for incorrect usage of '~'. I want use the '~60%' to express
> performance increased 'about' 60%, not '-60%'. This usage is unusual in
> English.

Oh its ~ not -. Did not see that on my small devices that I used at the
conference.

