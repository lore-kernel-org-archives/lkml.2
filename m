Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2KTGlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:41:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37566 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2KTGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <07672d0597e23fbc580843193415b89e81dba326.1352475033.git.viresh.kumar@linaro.org>
References: <07672d0597e23fbc580843193415b89e81dba326.1352475033.git.viresh.kumar@linaro.org>
Date: Tue, 20 Nov 2012 12:11:06 +0530
Message-ID: <CAKohpomX15TJ3gfk+s_18_2WuL2p314gCpv1fKS=AFWhHZJNew@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: stmpe: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2012 21:01, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch frees stmpe driver from tension of freeing resources :)
> devm_* derivatives of multiple routines are used while allocating resources,
> which would be freed automatically by kernel.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Ping!!
