Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1HEQsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:48:03 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:20750 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750855Ab1HEQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:48:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fWZ0rO8VM1mKCh2DxaRBBM7..ZxjYzkFAtBgLSALLuvS0WN
 Sf_66IdIR9bhtHW9qn0NAZ9gcJB281knHKtERvj15n1Uv8z6uZPly2pKp_z4
 Trdg6VfyAJjjj4ewp6uKCX1qVuyYrgcQM53H37WtwFTl_Mxgq7lJecl1CpK5
 C8e_EtMv62NE4IfoZLtz0YV.V_.dnkWaLqu3nNr1N74Im5ZkbMRsnCsJtl6e
 LUDb3W0b4CXt4Upknx81Qrg9__iSiq5bYTUjsivLRt14rKPjvekIf.4YAx7C
 strJ9NpSyRQFikIHG_IdGQjra5raI7BqmqfqK69Emo6NH0gt9tDWh12GeO1T
 9pMaR9NgCBdWNQ.KJK6TkBvSyedRxRC1GaO.Emj2O81XJdVFq9_tVA9WmIrl
 4WejxK5VLD1Y9WTVGmws88Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 11:47:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <20110805163948.GA11113@redhat.com>
Message-ID: <alpine.DEB.2.00.1108051146180.28580@router.home>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com> <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, Dave Jones wrote:

> Not sure if you were addressing my original report (quoted above), or the networking
> related report in this part of the thread. But anyway, I had it turned on (as well as just about
> every other debugging option).  I didn't see anything output from it though,
> just the LIST_DEBUG warnings.

But CONFIG_SLUB_DEBUG_ON was off? If slab debugging was on then this could
be an issue with full slab list management instead of partial lists.

