Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1I0Rg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:36:26 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64256 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1I0RgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:36:25 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1317143421-27286-3-git-send-email-pdeschrijver@nvidia.com>
References: <1317143421-27286-1-git-send-email-pdeschrijver@nvidia.com>
	<1317143421-27286-3-git-send-email-pdeschrijver@nvidia.com>
Date: Tue, 27 Sep 2011 10:36:24 -0700
Message-ID: <CAOesGMjqhGYUQ2XmuBBTBSUA6mKnOLF=Hmi86hRQhLiUMPtiBg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] arm/tegra: add support for ventana pinmuxing
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The series looks reasonable to me, I'll apply it together with some of
the other pending tegra patches from the list. Once Stephen's pinmux
devicetree code is in place some of this can be removed.

One comment on this patch description though:


On Tue, Sep 27, 2011 at 10:10 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Add support for ventana pinmuxing as a seaboard derivative. This is a cut down
> version of chromeos kernel commit 772f1b56e713be7a55759c2d5eadb9eb11d078db
> by Jong Kim <jongk@nvidia.com>.

Having a reference to a SHA1 in a foreign source tree isn't really
useful in the mainline kernel commit log.

I would just phrase it "This is a cut down version of work done by <....>"


-Olof
