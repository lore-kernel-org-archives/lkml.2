Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2KILxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:53:16 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33128 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2KILxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <1352461942.9150.1.camel@phoenix>
References: <1352461942.9150.1.camel@phoenix>
Date: Fri, 9 Nov 2012 17:23:14 +0530
Message-ID: <CAKohpokd-+8YDU7RPmhtAw64FNUnTY-j3s=Yh2b7UGP-=y_i-g@mail.gmail.com>
Subject: Re: [PATCH] pwm: spear: Staticize spear_pwm_config()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2012 17:22, Axel Lin <axel.lin@ingics.com> wrote:
> spear_pwm_config() is not referenced outside of this file, make it static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
