Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1GGSR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:17:57 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:26172 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752237Ab1GGSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:17:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 2WP9xAsVM1kOCWJ5NVAE5pj8C3aLQ0G5GVowwhYc1ZWVjf7
 aee08Bu1wsa6Z55ul.4dFrfnO33h17jFmNO68Xi9fKdRjZd.kA2kPOOb4x2L
 .eHBVx3o44IzLg6SwmvvgJ5gcOlW8gjJ40Vd8rHOdqy2NkW96lL8I6j6guP4
 VCjY3dh8lKX5Wksy0YK0Cw1bFdLMzir.ZoMhbHZVKzOGNuTyE6jwPUNSwpKR
 .jM3Ao_YGlPTJUaQXiIkD9hsOBE61v54tGT2gb.mkayLKXrvDJqiS2idygcy
 aaoYbDGyutZ1b0XwVuByKO0cQGsM5FALcYUNYHSX1ojIkrTli13RulVi7Und
 6VZeMdDLvDH8G.jX_oy3ZUI8Z
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 13:17:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, rientjes@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <alpine.DEB.2.00.1107072106560.6693@tiger>
Message-ID: <alpine.DEB.2.00.1107071314320.21719@router.home>
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1107072106560.6693@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Pekka Enberg wrote:

> Looks good to me. Christoph, David, ?

The reason debug code is there is because it is useless overhead typically
not needed. There is no point in optimizing the code that is not run in
production environments unless there are gross performance issues that
make debugging difficult. A performance patch for debugging would have to
cause significant performance improvements. This patch does not do that
nor was there such an issue to be addressed in the first place.


