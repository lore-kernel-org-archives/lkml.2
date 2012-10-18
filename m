Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2JRSF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:05:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55568 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2JRSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <20121018132928.GG16835@localhost.localdomain>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
	<20121018120820.GA17980@avionic-0098.mockup.avionic-design.de>
	<20121018132928.GG16835@localhost.localdomain>
Date: Thu, 18 Oct 2012 23:35:23 +0530
X-Google-Sender-Auth: eojIe12z8lLiPtWT1Xi-s5bePMk
Message-ID: <CAOh2x=nA683kWG=QTx5Bt5xYNnqQvf8eJD7JT9YN00kaYvr+bg@mail.gmail.com>
Subject: Re: [PATCH] pwm: add spear pwm driver support
From: viresh kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        spear--sw-devel@lists.codex.cro.st.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 6:59 PM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
>> Is there a reason to make this conditional? It looks like SPEAr has
>> moved to OF, so this will always be enabled anyway, won't it?
>
> Yes, I would remove it, SPEAr cannot boot without DT.

Add a dependency on OF in the Kconfig then.

Also i haven't seen any suspend/resume routines here. Missed them?
