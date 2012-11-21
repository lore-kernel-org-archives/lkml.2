Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2KUHyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:54:16 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38876 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KUHyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:54:15 -0500
MIME-Version: 1.0
In-Reply-To: <50ABBDCF.3080309@wwwdotorg.org>
References: <1353420282-18066-1-git-send-email-linus.walleij@stericsson.com>
	<50ABBDCF.3080309@wwwdotorg.org>
Date: Wed, 21 Nov 2012 08:54:14 +0100
Message-ID: <CACRpkdYdPFQFgVZahBU7oT9JwrPEmsNNjXQ4NpLVUzwqADTyVg@mail.gmail.com>
Subject: Re: [PATCH 4/7] gpiolib: return any error code from range creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 6:28 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/20/2012 07:04 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> If we try to create a range for a certain GPIO chip and the
>> target pin controller is not yet available it may return
>> a probe deferral error code, so handle this all the way
>> our by checking the error code.
>
> I think patches 3 and 4 need to be squashed together to avoid any "git
> bisect" issues?

OK that's correct I'll fix...

Linus Walleij
