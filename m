Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2KTR2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:28:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43132 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2KTR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:28:51 -0500
Message-ID: <50ABBDCF.3080309@wwwdotorg.org>
Date: Tue, 20 Nov 2012 10:28:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/7] gpiolib: return any error code from range creation
References: <1353420282-18066-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1353420282-18066-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 07:04 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> If we try to create a range for a certain GPIO chip and the
> target pin controller is not yet available it may return
> a probe deferral error code, so handle this all the way
> our by checking the error code.

I think patches 3 and 4 need to be squashed together to avoid any "git
bisect" issues?
