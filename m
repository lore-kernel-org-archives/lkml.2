Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2B2I3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:29:47 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37582 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab2B2I3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:29:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amit.kucheria@linaro.org designates 10.182.114.9 as permitted sender) smtp.mail=amit.kucheria@linaro.org
MIME-Version: 1.0
In-Reply-To: <4F4DCB59.5060205@linaro.org>
References: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org>
	<20120228094415.GA2868@mwanda>
	<4F4CC19D.9040608@linaro.org>
	<20120228133037.GG2817@mwanda>
	<4F4DCB59.5060205@linaro.org>
Date: Wed, 29 Feb 2012 10:29:46 +0200
Message-ID: <CAP245DWOCZx6Nd3a9LZCnHoTKMUmYWtkBwyM3vn9htmQ-edibA@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmalloc: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linaro-dev@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rusty Russell <rusty.russell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 8:53 AM, Dmitry Antipov
<dmitry.antipov@linaro.org> wrote:
> On 02/28/2012 05:30 PM, Dan Carpenter wrote:
>
>> Could you include that in the changelog when the final version is
>> ready?
>
>
> What changelog you're saying about?

Dmitry, he means your commit log message.
