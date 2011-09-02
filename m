Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1IBQSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:18:36 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:44439 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752941Ab1IBQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:18:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: j503wNsVM1n1qGw6IUev8aH1ozLYVjB9UQocj9MOoJ485Yq
 YBYkn_RophWDd5uLMs8ICxAkLLglBUgdxN0uEczLB579EoGDae6pRzrf97zP
 SCXplTlotz6sybiH1B2_0XVK4pBW7udKoanfOgxw9tiiSrxBhWhXHCwfwJSe
 sgpkMmaxyDJk7HkNlCJlS0BX0Le1FiZJOHcHPVKxSqy4VeBossxO3ZSAksgW
 f250PvVXKtpTz1RAUfrAf6jliCMcYwSM.X1fo5LL_ds4AN0apvNi1Qf_OmCM
 YnQAUUdFOtjM7wnhtp0s4lGB4gyvvxKsFnkX6EyeKPI12h4CRq8Z_5C79YUd
 QMMCcwUz540f69TNlxiMSOr3oVhUAHdXhvgaP9lHfpri6
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Sep 2011 11:18:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: George Shuklin <george.shuklin@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: si_swapinfo export
In-Reply-To: <1314978089.11870.2.camel@mabase>
Message-ID: <alpine.DEB.2.00.1109021117580.26757@router.home>
References: <1314978089.11870.2.camel@mabase>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011, George Shuklin wrote:

> Why si_swapinfo (from include/linux/swap.h) is not marked as
> EXPORT_SYMBOL_GPL? It's kinda hard to gain information about memory in
> module.

No one needed it from a module so far.

Submit your code with a patch that exports si_swapinfo if you need it.

