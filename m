Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2DLG4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:56:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43409 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab2DLG4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <4F864F1E.8030708@st.com>
References: <1334185214-27250-1-git-send-email-linus.walleij@linaro.org>
	<4F864F1E.8030708@st.com>
Date: Thu, 12 Apr 2012 08:56:13 +0200
Message-ID: <CACRpkdYVGTYVzZKjmK13w-oW0S=McTB2Ux7DmZCC_DRRGsogpg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] dma/amba-pl08x: add support for the Nomadik variant
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Alessandro Rubini <rubini@gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 5:42 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

>>               ch->serving = NULL;
>
> I meant removing this one too. :)

Argh! I'll spin a V3 with that removed and your review tag.

> Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

Thanks!
Linus Walleij
