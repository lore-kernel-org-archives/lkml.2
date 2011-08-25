Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1HYSqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:46:33 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:30263 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753872Ab1HYSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:46:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: I2LhVUYVM1kaaNV8H7sQJh3MPgOgpe_CRqBm.cGiaigPFzZ
 QA.Zr6nPZ3ofH55TBCOLs.1lvCz6Ju2eIM3MnwTrj0vZZvW.6qQsEe04gg4Z
 Q7sd43_1AXfL.G5JHkjtYAsEvlkVuNlZKXM_TFYkUw6YHtODn_13.pRiexNG
 EmWilg6bIqgP0Qtj7__cyS9IF439NZMnu8sRrUMJZfO4boQUMduGPP9QiIup
 vgXbNbjiO0fAei8RaykQsFn9dL2gKU6PzS_5PcEsxLl.6t3UECZ2v5pDLaST
 G6JUQfupypiOwuhoVKacQAbwkZTpVLaQDufkSsg3kgPc.UHA9fnzDTVoRel2
 hyC9ESgDPewfpo4KV7IfQqQSedSK9yYTHuxBFZR50yBxeZ7Mg83gID1dy55o
 lrjS43PLkgby5ErBlPcls1w--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 13:46:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.bottomley@HansenPartnership.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: <1e295500-5d1f-45dd-aa5b-3d2da2cf1a62@email.android.com>
Message-ID: <alpine.DEB.2.00.1108251341230.27407@router.home>
References: <1313650253-21794-1-git-send-email-gthelen@google.com> <20110818144025.8e122a67.akpm@linux-foundation.org> <1314284272.27911.32.camel@twins> <alpine.DEB.2.00.1108251009120.27407@router.home> <1314289208.3268.4.camel@mulgrave>
 <alpine.DEB.2.00.1108251128460.27407@router.home> <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com> <alpine.DEB.2.00.1108251206440.27407@router.home> <1e295500-5d1f-45dd-aa5b-3d2da2cf1a62@email.android.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, James Bottomley wrote:

> >Well then what is "really risc"? RISC is an old beaten down marketing
> >term
> >AFAICT and ARM claims it too.
>
> Reduced Instruction Set Computer.  This is why we're unlikely to have
> complex atomic instructions: the principle of risc is that you build
> them up from basic ones.

RISC cpus have instruction to construct complex atomic actions by the cpu
as I have shown before for ARM.

Principles always have exceptions to them.

(That statement in itself is a principle that should have an exception I
guess. But then language often only makes sense when it contains
contradictions.)

