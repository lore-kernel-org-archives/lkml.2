Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1FOT3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:29:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49481 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1FOT3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04992C060C@HQMAIL01.nvidia.com>
References: <20110615190754.11693.26335.stgit@ponder> <74CDBE0F657A3D45AFBB94109FB122FF04992C060C@HQMAIL01.nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 13:29:11 -0600
X-Google-Sender-Auth: ZwlZL9dDcqSgvrj7YKRQMYINJzk
Message-ID: <BANLkTimi8n-yik5g=f2jhVQPZoKLuWKgHQ@mail.gmail.com>
Subject: Re: [PATCH] spi/tegra: add devicetree support
To: Stephen Warren <swarren@nvidia.com>
Cc: "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erik Gilling <konkers@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 1:25 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Grant Likely wrote at Wednesday, June 15, 2011 1:08 PM:
>> Allow the tegra spi driver to obtain populate the spi bus with devices
>
> Remote "obtain"?

heh, oops.

>
>> from the device tree.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  .../devicetree/bindings/spi/spi_nvidia.txt         |    5 +++++
>>  drivers/spi/spi-tegra.c                            |   12 ++++++++++++
>>  2 files changed, 17 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/spi/spi_nvidia.txt
>>
>> diff --git a/Documentation/devicetree/bindings/spi/spi_nvidia.txt b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
>> new file mode 100644
>> index 0000000..bde450b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
>> @@ -0,0 +1,5 @@
>> +NVIDIA Tegra 2 SPI device
>> +
>> +Required properties:
>> +- compatible : should be "nvidia,tegra250-spi".
>> +- gpios : should specify GPIOs used for chipselect.
>
> Are things like reg, interrupts, and other general stuff implicit?
> I notice that fsl-spi.txt does specify those, but spi_altera.txt
> and spi_oc_tiny.txt don't.

yeah, standard properties are pretty much implicit.  I don't bother
writing the words if there isn't much value to them.  I've been
contemplating a tool that will take DT documentation written in a
certain form, and automatically fill in standard properties as needed,
but that's a project for another day.

g.
