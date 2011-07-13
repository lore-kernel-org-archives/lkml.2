Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1GMQHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:07:22 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:22952 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755972Ab1GMQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:07:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xALJifQVM1kqiKJ9.1cfhDZnZL_2DXpB.PGLhDXbi3Gw7rW
 F88ArfN2WsYLW4SvLyCVMdCvWXgtnVxa2DRUEAQcQMGvUVQvUN5mDk1eQBO4
 Pr2oDSKtlaFYKNelLQ8WJnX3A6MpUUMJQFvdkKtLCiKTIGWBVl2Kp3S9uqZN
 FtcofZMJztjWceO1mk7XYKqYgX5XbXeCQ4Bv6ew.wigc49XQ1DpTBR2.iZAL
 nXJngs0eJLz_citu8en2ejG.llSuOylS4oJX4P.t2qU9SWaGtsPpgDVcxRR_
 S7ZGaudiH4Qf3gSK4HSLb053rZDJpVgnptZSeXIHkcJfc.6eg
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Jul 2011 11:07:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slab: fix DEBUG_SLAB build
In-Reply-To: <alpine.LSU.2.00.1107130852590.6020@sister.anvils>
Message-ID: <alpine.DEB.2.00.1107131102290.29034@router.home>
References: <alpine.LSU.2.00.1107111152290.13035@sister.anvils> <alpine.DEB.2.00.1107121045050.2530@router.home> <alpine.LSU.2.00.1107121349590.1951@sister.anvils> <alpine.DEB.2.00.1107131037480.29034@router.home>
 <alpine.LSU.2.00.1107130852590.6020@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Hugh Dickins wrote:

> Really?  Here if I try that on x86_64 with #define ARCH_SLAB_MINALIGN 8, I get
> mm/slab.c: In function `cache_alloc_debugcheck_after':
> mm/slab.c:3160:10: warning: format `%lu' expects type `long unsigned int', but argument 3 has type `int'

Gosh. I thought integers (especially constants) are automatically
converted to the right format. Guess that is not possible here since the
format strings is not always available for checking.



