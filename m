Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0GTHOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:14:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:18899 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0GTHOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:14:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=R8VNFtNRcL5Xh3kWx2hFTv1lO1/XdL6s2l4k46zSD6SsVYCR7jM9mG7GrwcbuKbRY
	aHDVpt6iN900CJ9rtJKBg==
MIME-Version: 1.0
In-Reply-To: <1279219395-12088-1-git-send-email-segooon@gmail.com>
References: <1279219395-12088-1-git-send-email-segooon@gmail.com>
Date: Tue, 20 Jul 2010 00:14:08 -0700
X-Google-Sender-Auth: B_Ju1TWutfdBNmnNXZ02GfhwOfo
Message-ID: <AANLkTinFKH4Ed3UW3kMKdT5RJwmmE5n5k7nO01mB9xpO@mail.gmail.com>
Subject: Re: [PATCH 1/8] arm/mach-tegra: fix unsigned calcs
From: Colin Cross <ccross@android.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 11:43 AM, Kulikov Vasiliy <segooon@gmail.com> wrote:
> divider_u71 is unsigned, so this check is buggy:
> if (divider_u71 - 2 > 255 || divider_u71 - 2 < 0)
>
> If divider_u71 is 0 or 1 both checks are lying.
> So, it does not produce a buggy answer, but it is confusing.

Hi Kulikov,
Thanks for the patch.  This problem has been fixed in another patch in
the linux-tegra tree, I'll post it for review and update the
linux-next tree soon.

Colin Cross
