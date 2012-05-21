Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2EUUgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:36:44 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:26164 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754046Ab2EUUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:36:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: plug24IVM1mm5kRDlqqTL8q4.oBKBQA46f7bCLppruRiiAq
 Nt2eYM.9xub8hDLjcMiuKCmY0nmts8MlK9pP1i80jdoCLgbJF64RJnkgm2Zv
 wiiuHugPYvobH1YsYZ2KoR5h2MA.CtUBPAeKZtnCEgIRmapI1n.Ayn5G0GAs
 kVkpJcEkxSPpPlxULtdmq1i_KUqMv.Oa6LCMH2HPJwKcnQuRdobpUh3HTjIW
 Kq62nAD4AtzGTf6OHk6.jk6bZq8gy3qFZBBBFOWZO0ObPvVfEuyVNrxVPaK3
 NCd1DBcl63_gESqqSat93rJJUikO8VMs3W2k2HxQnfvcMV1wWvA7vO5_MUp0
 22M8hYtPmOWHpA_i_cbVtAZDXcE1s6MRfhgUERYlruqQQIz_FPbbdhNv.a4o
 TAwAIV8new2wjYJZF4IhrCsjJI5sT6kSmrtnj
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 May 2012 15:36:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
In-Reply-To: <20120521202904.GB12123@redhat.com>
Message-ID: <alpine.DEB.2.00.1205211535050.10940@router.home>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com> <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com> <20120521200118.GA12123@redhat.com> <alpine.DEB.2.00.1205211510480.10940@router.home>
 <20120521202904.GB12123@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Dave Jones wrote:

> It does create log files in the current dir with the parameters used.
> You should be able to grep for the pid that caused the actual oops.

Ugghh. It screws up the colors on my screeen. Lightgrey on white. Is there
any way to get these horrible escape sequences cleared out? If I use
"less" to view the output then there are just the escape sequences
visible.


