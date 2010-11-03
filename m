Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0KCOia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:38:30 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34389 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753280Ab0KCOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:38:28 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tlP9L_QVM1n.h6j3yVq2OgLH91jO3BHQ0DHYyNAA0CVBiEV
 UmQuYMy_YezY4CFkduXaL60vb6X1RBhL_pMkm6iOubYOqJmTozlK6_XxFWAK
 sjxHjEP_P2n7eOCtDIPghbuKFPUK.fJwUHYhooEt3p5lMAvqRcnfr.BfhRj5
 xim7WqmQ70S2zKyN2FmC.ldLkuua7YdMuRGWXV2WJrBhMZ_oD3H_dDVCr5yY
 a28E8bytLgc2RrZ3IbSb4CvlIw7g-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 3 Nov 2010 09:38:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jesper Juhl <jj@chaosbits.net>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
In-Reply-To: <alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net>
Message-ID: <alpine.DEB.2.00.1011030937580.10599@router.home>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net> <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com> <20101031173336.GA28141@balbir.in.ibm.com> <alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Jesper Juhl wrote:

> On Sun, 31 Oct 2010, Balbir Singh wrote:

> > > There are so many placed need vzalloc.
> > > Thanks, Jesper.


Could we avoid this painful exercise with a "semantic patch"?
