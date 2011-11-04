Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1KDPyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:54:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48995 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1KDPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1320408281.28679.1.camel@phoenix>
References: <1320408281.28679.1.camel@phoenix>
Date: Fri, 4 Nov 2011 16:54:16 +0100
Message-ID: <CACRpkdb1BkMw=QPRfp+8HqQzKS6Z1+K=DhS47dofPTTEURR2=g@mail.gmail.com>
Subject: Re: [PATCH] [CPUFREQ] db8500: fix build error due to undeclared i variable
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 1:04 PM, Axel Lin <axel.lin@gmail.com> wrote:

> The variable i is removed by commit ded8433
> "[CPUFREQ] db8500: remove unneeded for loop iteration over freq_table",
> but current code to print available frequencies still uses the i variable.
> Thus add the i variable back to fix below buld error:

How could I miss this? :-(

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
