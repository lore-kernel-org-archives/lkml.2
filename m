Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2HaKVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:21:23 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50890 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab2HaKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <504084B9.3000701@ti.com>
References: <1344961473-13675-1-git-send-email-sourav.poddar@ti.com>
	<CAKdam57L8txFtE9ahy3u3vLW0XRP5z4QaNQKVFj9KaEFZE1qvg@mail.gmail.com>
	<503229F5.4030405@ti.com>
	<CAKdam543ATO96rbhgCWKtGUGRQ_+=KSyAk-nGBknjC+BvJSmOw@mail.gmail.com>
	<504084B9.3000701@ti.com>
Date: Fri, 31 Aug 2012 15:51:20 +0530
Message-ID: <CAKdam573NqiCd2=CQ2kg1g+VqjS6z8g=QbPfMZZbm8P98yDP_A@mail.gmail.com>
Subject: Re: [PATCHv3 0/4] Add device tree data for omap5
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Fri, Aug 31, 2012 at 3:02 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> Hi Sourav,
>
> While rebasing your series on top of Tony's lo/devel-dt, I realized that the keypad nodes are not located at the correct place :-(
>
> At the moment they are just floating at the top level of the dts while they belong to the ocp bus and thus should be put there.
>
My bad, never realised always used it at the top level. Sorry for the
inconvenience.
> I fixed that since it was trivial and cleaned as well the changelog and the comments to aligned then properly. I added as well the physical address to the node name and a label for easy reference at board level.
>
Thanks for fixing it up.
> I did some basic test on my OMAP4 sdp, but that all I can do so far.
>
> Could you just check if this is still fine for OMAP5 before I ask Tony to pull that.
>
I just booted the below mentioned branch and its booting fine on omap5. Did
some keypad functionality test also and keypad seems to be working
fine on omap5.
> I based that on top of Tony's DT patches due to conflict with the existing MMC patch in it.
>
>
>
> The following changes since commit 85d7ff9b907685b6469058888f1d961b3e8d47ad:
>   Olof Johansson (1):
>         ARM: omap: add dtb targets
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.7/dts
>
> Sourav Poddar (6):
>       arm/dts: omap5-evm: Add I2C support
>       arm/dts: omap5-evm: Add tmp102 sensor support
>       arm/dts: omap5-evm: Add keypad data
>       arm/dts: omap5-evm: Add bmp085 sensor support
>       arm/dts: omap4-sdp: Add keypad data
>       Documentation: dt: i2c: trivial-devices: Update for tmp102
>
>  .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
>  arch/arm/boot/dts/omap4-sdp.dts                    |   70 ++++++++++++++++++++
>  arch/arm/boot/dts/omap4.dtsi                       |    5 ++
>  arch/arm/boot/dts/omap5-evm.dts                    |   33 +++++++++
>  arch/arm/boot/dts/omap5.dtsi                       |   40 +++++++++++
>  5 files changed, 149 insertions(+), 0 deletions(-)
>
> Regards,
> Benoit
>

Thanks,
Sourav
