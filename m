Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0JBUVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 16:21:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0JBUVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 16:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=GAF4/kzvenQUn4YsDGe/x0Jw8KExGjB5kWAcgdVTAf6txEXfDETPCjZYYkMvEQLetd
         Q8Svf/rDazARbhCXs2dg==
MIME-Version: 1.0
In-Reply-To: <AANLkTinSgSWakhXaHN9svA7ruRF6w4tbOugdd5g+xF2i@mail.gmail.com>
References: <1285901335-26354-1-git-send-email-ccross@android.com>
	<1285901335-26354-2-git-send-email-ccross@android.com>
	<AANLkTinSgSWakhXaHN9svA7ruRF6w4tbOugdd5g+xF2i@mail.gmail.com>
Date: Sat, 2 Oct 2010 13:21:28 -0700
X-Google-Sender-Auth: 6CgFhwDT49UBP6aNabmNNgefeQE
Message-ID: <AANLkTikTLgNe+JSeBAumsAsDvDxUzepf62CgFqWaq8LY@mail.gmail.com>
Subject: Re: [PATCH 2/2] gic: Export irq chip functions
From: Colin Cross <ccross@android.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 11:03 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/10/1 Colin Cross <ccross@android.com>:
>
>> Some systems combine the GIC with an external interrupt controller.
>
> Which ones?
>
> In-tree systems (in which case it would be natural to include these changes
> the patch series) or stuff you plan to submit later?

Tegra, these patches are a precursor to the Tegra suspend support
series.  If there's nothing obviously wrong with these, I'll repost
them along with the rest of the series.
