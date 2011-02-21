Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1BUG4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:56:50 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1BUG4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XvVTxemDyjzy6ibknjFlXetq9azPAjFyQrVHq4JDLt+IHgE75kzLEPO+2dR7gVbkAa
         Z31sqIyvl/wQuH/dPNnA==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=MaoEqcOwnsvwWvPsUVFMYXfGsLR6zUbHMQ56R@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-5-git-send-email-ccross@android.com>
	<AANLkTi=MaoEqcOwnsvwWvPsUVFMYXfGsLR6zUbHMQ56R@mail.gmail.com>
Date: Sun, 20 Feb 2011 22:56:40 -0800
X-Google-Sender-Auth: zWLnm3L_pB9mcYsak9liQtk1Jvo
Message-ID: <AANLkTik+g=42YjLzDgGDifJ4Ci+M2h=h94BRAo++E7DH@mail.gmail.com>
Subject: Re: [PATCH v2 03/21] ARM: tegra: clock: Drop debugging
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

On Sun, Feb 20, 2011 at 8:07 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Same here, I know the patch is obvious but just a one-liner in the
> patch description is common practice.
>
> Acked-by: Olof Johansson <olof@lixom.net>

I will add:
Drop the unnecessary pr_debug calls to avoid having to maintain them.
