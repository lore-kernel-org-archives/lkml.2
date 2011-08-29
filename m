Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1H2Rfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:35:50 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:40149 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754529Ab1H2Rfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:35:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0CF.04UVM1n1teMZuzZ.BDyCFLE43ErGt5sm_Jey.dWNC6U
 YxgUlj9wJCqe5ZcWDoc4pU3Pj_ubcetjaHlKIYqTO7L69VgJuATItBRgq.Go
 A08zk_IE8X77ACKc_uJW1fgMlr_aXFQOX0xPOEtgDQyFZDko8GwnJCCFgd.R
 cWdiEKMF.KtzUH2o9mYAQhnlXsg6Z8a1rZoS0QddrTk8ymB07q0W42sF9gkF
 lmALm3kLVH.M7GqNS_0JyeX2H9lk35fTmy29ARtAVphepkOQGkzBC7THHGsW
 dW0n8tLL_oyrcZTxb_723mv9DaiDNIgxKPaREMQM0mjKw4g70naVpHfpbrYV
 GYkOgHK3CMMUUmfyepMvqG4bRWCnX3XPFTog2ixgq7FlvDvbk8Dhc98VIbpk
 QbExSWngQ_fq4spopqiVd6Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 29 Aug 2011 12:35:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Weinberger <richard@nod.at>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/9] um: disable CMPXCHG_DOUBLE as it breaks UML build
In-Reply-To: <1314634419-24766-2-git-send-email-richard@nod.at>
Message-ID: <alpine.DEB.2.00.1108291235180.16005@router.home>
References: <1314634419-24766-1-git-send-email-richard@nod.at> <1314634419-24766-2-git-send-email-richard@nod.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Richard Weinberger wrote:

> Commit b789ef518b2a7231b0668c813f677cee528a9d3f tests for cmpxchg_double
> support in the SLUB code and it breaks UML builds with SLUB. Since UML
> does not support checking for CPU features, disable CMPXCHG_DOUBLE just
> like CMPXCHG_LOCAL is disabled for UML.

Reviewed-by: Christoph Lameter <cl@linux.com>
