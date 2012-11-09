Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2KIKY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:24:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65527 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2KIKY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:24:56 -0500
MIME-Version: 1.0
In-Reply-To: <509BE7C5.4030109@wwwdotorg.org>
References: <1352375742-29611-1-git-send-email-linus.walleij@stericsson.com>
	<509BE7C5.4030109@wwwdotorg.org>
Date: Fri, 9 Nov 2012 11:24:55 +0100
Message-ID: <CACRpkdaBTjAuifBrZNOuXsrq-TQHQgns4cRF=-qYoqKVGxusdQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl/nomadik: make independent of prcmu driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 6:11 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Do you actually need to store the run-time data in struct
> nmk_pinctrl_soc_data too? I would have expected all the soc_data
> pointers to remain const, and to store the runtime register pointer
> somewhere else, and perhaps pass it as a separate parameter to the
> relevant init functions; wouldn't that make the patch much smaller?

OK point taken, I'm sending a v2...

Yours,
Linus Walleij
