Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2BZVX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 16:23:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56839 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2BZVX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 16:23:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.236.197.98 as permitted sender) smtp.mail=olof@lixom.net
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120224232942.GL25293@ponder.secretlab.ca>
References: <1329175275-19404-1-git-send-email-swarren@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BCE0C@HQMAIL01.nvidia.com>
	<20120224232942.GL25293@ponder.secretlab.ca>
Date: Sun, 26 Feb 2012 13:23:26 -0800
Message-ID: <CAOesGMg6w+bQVhAyEKCsT1SMGVFEmnaOvvchqzVKzF2XJhCnYg@mail.gmail.com>
Subject: Re: [PATCH] gpio: tegra: Fix build issue due to irq_domain rework.
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 3:29 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Feb 24, 2012 at 03:12:37PM -0800, Stephen Warren wrote:
>> Stephen Warren wrote at Monday, February 13, 2012 4:21 PM:
>> > Commit 7da5a66 "irq_domain: Remove 'new' irq_domain in favour of the
>> > ppc one" changed the set of available irq domain APIs. Update the Tegra
>> > GPIO driver to account for those changes, to solve a build break.
>>
>> Grant, Linus,
>>
>> Could this please be checked in; linux-next since about Feb 6th doesn't
>> build for Tegra without it.
>
> This doesn't apply against the gpio tree since I didn't pick up the DT patches.
> It looks like Olof did.  (3391811c & 6f74dc9bc).  The irq_domain branch is
> stable now, so it can be merged into the arm-soc tree before applying this
> patch.

Yep, can do.

Just to clarify, the branch that is guaranteed to be stable is
irqdomain/next on your linux-2.6 repo?


-Olof
