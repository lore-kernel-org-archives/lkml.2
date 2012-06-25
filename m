Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab2FYIHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:07:08 -0400
Received: from service88.mimecast.com ([195.130.217.12]:46141 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2FYIHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:07:06 -0400
Message-ID: <4FE81C23.30203@arm.com>
Date: Mon, 25 Jun 2012 09:06:59 +0100
From: viresh kumar <viresh.kumar2@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rajeev kumar <rajeev-dlh.kumar@st.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
References: <20120625141140.c6d71065dab293005514ee1a@canb.auug.org.au> <4FE8009A.4020503@st.com>
In-Reply-To: <4FE8009A.4020503@st.com>
X-MC-Unique: 112062509070301602
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/12 07:09, Rajeev kumar wrote:
> 1. Protecting clk_get/clk_put* calls under macro 'CONFIG_HAVE_CLK' in
> the driver.

Not at all now.

> 2. Adding a check in Kconfig for HAVE_CLK.
> (But that will limit the compilation of this driver for only platforms
> which are ARM based/or similar).

Not actually required

> 3. We can pick the patches circulated by Viresh Kumar where we don't
> have HAVE_CLK defined for x86_64, then the inline routines like
> following should come into play:

That's the best. But probably Mark need to pull in AKPM's tree first into
sound-asoc tree. Mark?

--
Viresh

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

