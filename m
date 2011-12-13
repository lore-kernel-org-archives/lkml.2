Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1LMLzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:55:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61983 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1LMLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:54:56 -0500
MIME-Version: 1.0
In-Reply-To: <1323766064-13425-1-git-send-email-pratyush.anand@st.com>
References: <1323766064-13425-1-git-send-email-pratyush.anand@st.com>
Date: Tue, 13 Dec 2011 12:54:55 +0100
Message-ID: <CACRpkdakPexKdxfkYociEsie2TWDdK60-gbm71D64tyrZ3HT0Q@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/dw_dmac: Add support for device_prep_dma_sg
From: Linus Walleij <linus.walleij@linaro.org>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: mirko.gardi@st.com, Vincenzo.FRASCINO@st.com, bhavna.yadav@st.com,
        bhupesh.sharma@st.com, Amit.VIRDI@st.com, vipulkumar.samar@st.com,
        deepak.sikri@st.com, rajeev-dlh.kumar@st.com, vipin.kumar@st.com,
        shiraz.hashim@st.com, armando.visconti@st.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 9:47 AM, Pratyush Anand <pratyush.anand@st.com> wrote:

> Memory to memory copy with scatter gather option has been implemented in
> this patch. Driver can manage even if number of nodes in src and dst
> list is different.
>
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
