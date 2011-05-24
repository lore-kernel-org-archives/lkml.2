Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1EXVOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:14:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1EXVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=anW2XH7QNgKOYaO9WBu/uKSzgAbEkouvtgH6JSFmY6bykkfKH5Kmjrt06gQyguailg
         338+nyfpm7dB36P0M3G/Hck11AIrL2KWZH1maEidcN//P4+weU5vigoKvMpV3nm07bZI
         Yu/MzXQgPxCDsSOz6yDBivfEloZ+vKfpYMHxc=
MIME-Version: 1.0
In-Reply-To: <20110523032503.GA22189@sortiz-mobl>
References: <1305967300-16337-1-git-send-email-linus.walleij@stericsson.com>
	<20110523032503.GA22189@sortiz-mobl>
Date: Tue, 24 May 2011 23:14:22 +0200
X-Google-Sender-Auth: Dsdonl-nYc7eRkGXCfkfklYlp8o
Message-ID: <BANLkTikK3mZmSZm0YMcOjXqO0QimOftoWQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] Ux500 PRCMU into MFD v4
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/23 Samuel Ortiz <sameo@linux.intel.com>:

> Hi Linus,
> (...)
> I'd rather see this one going through your tree as it does contain many arch
> related changes. Please add my ACK to the MFD parts.
> Also, please cc me on your pull request so that I can fix the mfd_data from
> patch #13 before sending my pull request.

OK said and done. Hold on for when/if Torvalds pulls my stuff in.

Yours,
Linus Walleij
