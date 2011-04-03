Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1DCSpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 14:45:20 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40522 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753025Ab1DCSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 14:45:19 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: bCCou5QVM1mErzDlqnblpvT_24bf5LJIJ9p17JtpUw9I81D
 p763gIYstfNoFf9_7C6RIYKNvEnCHr7dIbIdc91fWzgyK9HtGib2OTLY2r8n
 2_4FQifQVVvtWqbjvDO72hKvJLj7Q_r_tAbRcuteTccvhdJQ20XiOUtktDVr
 Bq8FFPfePRDDz2uoJDFen56JT5wmDB3Cj3jRa4S7U38ND6mOAaM5Vczee_zs
 FUDrnCeR5wOltGTYqQVlxYr42ecDWZLWFnzJvfBPhkA5mB_QmsxrqyIqOSe6
 Vs8kAC.gMMsmrIwk4Y8qt0Pc5ZemGNnyNNpoM9tpQDXOCtnyI
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 3 Apr 2011 13:45:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
In-Reply-To: <20110403184514.AE4E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104031342540.15317@router.home>
References: <20110401221921.A890.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104010945190.17929@router.home> <20110403184514.AE4E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Apr 2011, KOSAKI Motohiro wrote:

> 1) Some bios don't have such knob. btw, OK, yes, *I* can switch NUMA off completely
> because I don't have such bios. 2) bios level turning off makes some side effects,
> example, scheduler load balancing don't care numa anymore.

Well then lets add a kernel parameter that switches all NUMA off.
Otherwise: If you just run a kernel build without NUMA support then you have a similar
effect.

Re #2) If you have the system toss processes around the system then the
load balancing heuristics does not bring you any benefit.


