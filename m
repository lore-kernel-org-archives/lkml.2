Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2ASRAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:00:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37587 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2ASRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:00:44 -0500
MIME-Version: 1.0
In-Reply-To: <104f6d8b3c4a2d65dce9eb32364d32eba637c48d.1326876464.git.viresh.kumar@st.com>
References: <cover.1326876464.git.viresh.kumar@st.com>
	<104f6d8b3c4a2d65dce9eb32364d32eba637c48d.1326876464.git.viresh.kumar@st.com>
Date: Thu, 19 Jan 2012 18:00:43 +0100
Message-ID: <CACRpkdYjLyYx-pDLA+FqT+=Vdop4jF4+ex6D6o9udNbN57+=Zg@mail.gmail.com>
Subject: Re: [PATCH V2 03/12] dmaengine: Pass dma_slave_config .device_fc =
 NULL for all existing users
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        egtvedt@samfundet.no, hskinnemoen@gmail.com, kernel@pengutronix.de,
        perex@perex.cz, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 10:11 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> .device_fc is added in struct dma_slave_config recently. All user drivers, which
> want DMA to be the flow controller must pass this field as false. As earlier
> driver don't look to use this feature, mark it false for now.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Viresh,
Linus Walleij
