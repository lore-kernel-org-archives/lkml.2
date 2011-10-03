Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1JCPV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:21:26 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:48825 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756451Ab1JCPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:21:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: l4Qk2fIVM1nfLUcPzi4pte7GclfXXofvkFqjfCAgAYxonDe
 tbZCP.8X2V8ebi0t6dOuNaE_4NzFx0tSPehfjuBgwT82QMknWSDKBA.MHN31
 4hkjYrt7Rxl7vBsUnCfl270iNUPky3Q4zi3U_ajGRJ7CPYSSbhJXHbp7lzPq
 UBDvMZToWuJY5ff7qzFIV5p5sRlnNSJ11m3Bkczvrhkn4e83nntDqe5LQPLx
 CfsvED9ROSvJDZBtl5Ya6Cl6FkXj4iVeCxOHI.WEjWQNTtbJN6Wq34U.YqOL
 fLQ1XWJziGDZx6JVs2B3GICYKJpn9MfsdBH3NjQ7nqDa32OYPNwqDFRLTmvj
 Fc5iwE5A4.bATzZN0dwOYzq1azavEWvzKhrZ7ImDIK0HXQdvcNqnsDG5JXPY
 az3UFRIZlN7WK4TiV1nsc1A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 3 Oct 2011 10:21:18 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Shi, Alex" <alex.shi@intel.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] slub Discard slab page only when node partials > minimum
 setting
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B5FD97584A3@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1110031020450.11713@router.home>
References: <1315188460.31737.5.camel@debian>  <alpine.DEB.2.00.1109061914440.18646@router.home>  <1315357399.31737.49.camel@debian>  <alpine.DEB.2.00.1109062022100.20474@router.home>  <4E671E5C.7010405@cs.helsinki.fi> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1109071003240.9406@router.home>  <1315442639.31737.224.camel@debian>  <alpine.DEB.2.00.1109081336320.14787@router.home>  <1315557944.31737.782.camel@debian>
 <1315902583.31737.848.camel@debian>  <CALmdxiMuF6Q0W4ZdvhK5c4fQs8wUjcVGWYGWBjJi7WOfLYX=Gw@mail.gmail.com>  <1316050363.8425.483.camel@debian>  <CALmdxiMrDNDvhAmi88-0-1KBdyTwExZPy3Fh9_5TxB+XhK7vjw@mail.gmail.com>  <1316052031.8425.491.camel@debian>
 <1316765880.4188.34.camel@debian>  <alpine.DEB.2.00.1109231500580.15559@router.home> <1317290032.4188.1223.camel@debian> <alpine.DEB.2.00.1109290927590.9848@router.home> <6E3BC7F7C9A4BF4286DD4C043110F30B5FD97584A3@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Oct 2011, Shi, Alex wrote:

> >From my viewpoint, the patch is still helpful on server machines, while no clear
> regression finding on desktop machine. So it useful.

Ok. We still have a few weeks it seems before the next merge phase.

