Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1DTCkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:40:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab1DTCkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=GBQq/QmjBEA6oMhnH9VE11Lig2kCWlASPcdYuwfAbeS5192hxujd43cdehj1S+QWMS
         Fcu7JKs/nzUhObsOG9bQ==
MIME-Version: 1.0
In-Reply-To: <4DA7A914.5020804@codeaurora.org>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
	<4DA7A914.5020804@codeaurora.org>
Date: Tue, 19 Apr 2011 19:40:39 -0700
X-Google-Sender-Auth: v51yTiY_KhToUllRmi7dIGYkCxY
Message-ID: <BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 7:10 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 04/14/2011 04:00 PM, Simon Glass wrote:
>> From: Simon Glass <sjg@google.com>
>>
>> ARM uses its own BUG() handler which makes its output slightly different
>> from other archtectures.


>> Signed-off-by: Simon Glass <sjg@chromium.org>
>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks Stephen. Since there were no other comments I have submitted
this to RMK's patch tracking system.

Regards,
Simon

>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>
