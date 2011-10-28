Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1J1JT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 05:19:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53614 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1J1JT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 05:19:57 -0400
MIME-Version: 1.0
X-Originating-IP: [85.13.70.251]
In-Reply-To: <20111028081738.GA12383@tbergstrom-lnx.Nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
	<1319561644-6160-3-git-send-email-pdeschrijver@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173E1B49AA@HQMAIL01.nvidia.com>
	<20111028081738.GA12383@tbergstrom-lnx.Nvidia.com>
Date: Fri, 28 Oct 2011 02:19:56 -0700
Message-ID: <CAOesGMi4NgYXUf8HtFM_=YX1aGnHbj2Wh8Wq7w=y17=Z21dqjQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] arm/tegra: prepare pinmux code for multiple tegra variants
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 1:17 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> On Thu, Oct 27, 2011 at 09:59:49PM +0200, Stephen Warren wrote:

> Hmm. Maybe if I split it in 2 patches? 2 rename and 1 modification?

Yep, please do renames separately (you can rename all of them in one
patch, but no modifications in that please, besides what you need to
build with the new filename).


-Olof
