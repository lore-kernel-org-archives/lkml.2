Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1FOVBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:01:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48911 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1FOVA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik6C1mBeitYkA+NNM6XAhNY9cbgOw@mail.gmail.com>
References: <20110615193734.23641.8004.stgit@ponder> <BANLkTinij15PZw11Y3Qt=PV1kkP1pw1oaszTdMfD55Cf8cOJkw@mail.gmail.com>
 <BANLkTik6C1mBeitYkA+NNM6XAhNY9cbgOw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 15:00:37 -0600
X-Google-Sender-Auth: b-SjYiO8h5BuAiXr5rQXkmwl9_s
Message-ID: <BANLkTik4fna_C-1JHt9KoF4UsYCuqVy6Nw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio/tegra: Move Tegra gpio driver to drivers/gpio
To: Colin Cross <ccross@android.com>
Cc: Erik Gilling <konkers@android.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        spi-devel-general@lists.sourceforge.net,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 2:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Jun 15, 2011 at 2:21 PM, Colin Cross <ccross@android.com> wrote:
>> On Wed, Jun 15, 2011 at 12:37 PM, Grant Likely
>> <grant.likely@secretlab.ca> wrote:
>>> As part of the gpio driver consolidation, this patch moves the Tegra driver
>>> into drivers/gpio
>>>
>>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>> ---
>>>
>>> If there are no objections, I'll merge this via gpio/next
>>
>> I have this patch as part of a series that should get posted later
>> this week, as well as a patch on top of it that depends on this change
>> and another change in my tree, but I'm pessimistic that my series will
>> get in to 3.1 since it depends on some common consolidation that
>> hasn't been agreed upon yet.  So,
>> Acked-by: Colin Cross <ccross@android.com>
>>
>> Put it in gpio/next, and I'll make sure any other Tegra patches with
>> dependencies get pulled after yours.
>
> How about I put it in a separate branch so that if you need to pull it
> for dependencies then you can do so without pulling in all the
> gpio/next commits.

I've pushed it out to the following branch.  If everything looks okay
to you, then I'll merge it into gpio/next and push it out.

The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio/next-tegra

Grant Likely (2):
      gpio/tegra: Move Tegra gpio driver to drivers/gpio
      gpio/tegra: add devicetree support

 .../devicetree/bindings/gpio/gpio_nvidia.txt       |    7 +++++++
 arch/arm/mach-tegra/Makefile                       |    1 -
 drivers/gpio/Makefile                              |    1 +
 .../mach-tegra/gpio.c => drivers/gpio/gpio-tegra.c |   10 ++++++++++
 4 files changed, 18 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
 rename arch/arm/mach-tegra/gpio.c => drivers/gpio/gpio-tegra.c (97%)
