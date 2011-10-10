Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1JJRND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:13:03 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:33741 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752525Ab1JJRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:13:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yrNozBAVM1nhqUkC_dE_BZVPv096ZdrJHgo1UmH7La1Wv2t
 wU0LetrUM0hXo5rcHHOKG_4L0oghMkbt_shUAP3mnG_Ec2RLm7D7I4m_I4M0
 zQ.A0LhurSHhv_qFGmN4GfGyzTSNjz6GBjE20M1rj_1H1cuBQTryTa9HfI4_
 M4_XgiWbI8rr0FCpbrD6QSlWMe.l3Y2rT37dKk5fj0Mtkv.7W7eYtAB6pFpj
 .WcbUpf7Sh.LTyspmO32X_ZdeDhPtj6G.TBamMdLLSwTLjJ1NE_ZF4UeOjrt
 e5sxZFLSsmXiMeivQ5odQUFh3EiuhhBMTUZfPOdHavsRNzFJRflUNBGbU9SD
 aERRkN_hURJeKsX2woLZVUjx1xGYRjFfudZao4olmCcXnkCR_A9jr..UpFtM
 DkoLgEKgi9L6CPUJkGm.eNi8-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 10 Oct 2011 12:12:57 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] slub Discard slab page only when node partials > minimum
 setting
In-Reply-To: <1318141715.27949.144.camel@debian>
Message-ID: <alpine.DEB.2.00.1110101212010.18349@router.home>
References: <1315188460.31737.5.camel@debian>  <alpine.DEB.2.00.1109061914440.18646@router.home>  <1315357399.31737.49.camel@debian>  <alpine.DEB.2.00.1109062022100.20474@router.home>  <4E671E5C.7010405@cs.helsinki.fi> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1109071003240.9406@router.home>  <1315442639.31737.224.camel@debian>  <alpine.DEB.2.00.1109081336320.14787@router.home>  <1315557944.31737.782.camel@debian>
 <1316765880.4188.34.camel@debian>  <alpine.DEB.2.00.1109231500580.15559@router.home>  <1317290032.4188.1223.camel@debian>  <alpine.DEB.2.00.1109290927590.9848@router.home>  <6E3BC7F7C9A4BF4286DD4C043110F30B5FD97584A3@shsmsx502.ccr.corp.intel.com> 
 <alpine.DEB.2.00.1110031020450.11713@router.home> <1318141715.27949.144.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Oct 2011, Alex,Shi wrote:

> I tested multi-threads loopback netperf on our machines, no clear
> regression or improvement find on our NHM-EP/NHM-EX/WSM-EP machine.

What are your criteria for a regressio?

> but on our 4 sockets tigerton machine with 2048 clients, performance
> increase 20% for TCP_RR subcase, and 10% for TCP_STREAM32 subcase;
> and on our 2 sockets harpertown machine, the TCP_RR subcase increase
> 15%.
>
> The data is quite good!

Sounds encouraging.


