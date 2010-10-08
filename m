Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0JHPpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:45:22 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36569 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753784Ab0JHPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:45:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: IFZjCNEVM1mcMDNbsxU6JI0Xo0rlfxDTrz7tPFPiLV4JMm0
 hEtB0v6Ac3msmreC0kjJPitxmZp21etWQf47Obt1dcr.miT2ipqvmTQ4VVcK
 xketdkPnjGV1m4SwbIFf4Ppy3bNQv.VujNMCESlxY8QpuUUEI7kmd_nIG2fz
 Y4sKEUWq1xkIF_Nqdmrms5NAEuPv7h8a.4TiqZC0l5uoEBfnFYTb0pj61d4b
 z
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 8 Oct 2010 10:45:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <20101008090427.GB5327@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1010081044530.30029@router.home>
References: <20101008104852.803E.A69D9226@jp.fujitsu.com> <20101008090427.GB5327@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Balbir Singh wrote:

> I am not sure if this makes sense, since RECLAIM_DISTANCE is supposed
> to be a hardware parameter. Could you please help clarify what the
> access latency of a node with RECLAIM_DISTANCE 20 to that of a node
> with RECLAIM_DISTANCE 30 is? Has the hardware definition of reclaim
> distance changed?

10 is the local distance. So 30 should be 3x the latency that a local
access takes.

> I suspect the side effect is the zone_reclaim_mode is not set to 1 on
> bootup for the 2-4 socket machines you mention, which results in
> better VM behaviour?

Right.

