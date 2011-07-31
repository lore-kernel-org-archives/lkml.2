Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1GaA1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:27:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41551 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab1GaA1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <5521ee74eef41cf26a9f1ece6dadd32cca529cce.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<5521ee74eef41cf26a9f1ece6dadd32cca529cce.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:27:38 +0200
X-Google-Sender-Auth: bJ5pmNr8UqM1Q7yQmNgX4WecXYI
Message-ID: <CAKnu2MpUj9JDDg8psPf5WaGGFSZGmPcmtiujKiFzcHM71RqLKQ@mail.gmail.com>
Subject: Re: [PATCH 11/18] dmaengine/amba-pl08x: max_bytes_per_lli is
 TRANSFER_SIZE * src_width (not MIN(width))
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: pratyush.anand@st.com, rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Viresh Kumar <viresh.kumar@st.com>:

> max_bytes_per_lli = bd.srcbus.buswidth * PL080_CONTROL_TRANSFER_SIZE_MASK;
> This is confirmed by ARM support guys.

Great and THANKS for your tiresome research in ironing out the ambiguities
in the manuals.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
