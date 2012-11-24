Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2KXRtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 12:49:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45837 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2KXRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 12:49:08 -0500
Message-ID: <50B10883.5040101@nvidia.com>
Date: Sat, 24 Nov 2012 10:48:51 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpiolib: rename pin range arguments
References: <1353484243-6115-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1353484243-6115-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 12:50 AM, Linus Walleij wrote:
> To be crystal clear on what the arguments mean in this
> funtion dealing with both GPIO and PIN ranges with confusing
> naming, we now have gpio_offset and pin_offset and we are
> on the clear that these are offsets into the specific GPIO
> and pin controller respectively. The GPIO chip itself will
> of course keep track of the base offset into the global
> GPIO number space.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

