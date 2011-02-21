Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1BUHAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:00:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27703 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1BUHAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EvH26KhX2izLoEL4hWVE3bd9GZ3B41jQIdfaN10coxUgkyA3nDfn7UsFEm5mQ91DoI
         1cG2Hrymr1YuUKrWahjg==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=1Sxsa7ZwUSX6NK2M5Sp3Ww20CumCrividGsrx@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-11-git-send-email-ccross@android.com>
	<AANLkTi=1Sxsa7ZwUSX6NK2M5Sp3Ww20CumCrividGsrx@mail.gmail.com>
Date: Sun, 20 Feb 2011 23:00:22 -0800
X-Google-Sender-Auth: iMDeGhgA2kjprSNego8drMzixhk
Message-ID: <AANLkTinzjKd2gT9v73hczQ__35+V5LB7puD8ATuZxJD0@mail.gmail.com>
Subject: Re: [PATCH v2 09/21] ARM: tegra: clock: Move unshared clk struct
 members into union
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 8:10 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Same here, short description. With that:
>
> Acked-by: Olof Johansson <olof@lixom.net>
>

I will add:
Creates a union of a struct for each type of clock to reduce memory
usage and clarify which members are used by all clocks and which are
used by a single type.
