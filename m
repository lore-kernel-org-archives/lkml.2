Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2IKIoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:44:16 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:32849 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213Ab2IKIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <504EF587.3080903@ti.com>
References: <1347345381-4390-1-git-send-email-kishon@ti.com>
	<504EF587.3080903@ti.com>
Date: Tue, 11 Sep 2012 14:14:11 +0530
Message-ID: <CAAe_U6JoW36bWSamHkRV66JX5fZ3QkLQv=4XJr-MuaFgaRjOaA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] arm/dts: omap: add dt data for MUSB
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: balbi@ti.com, linux@arm.linux.org.uk, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, tony@atomide.com, rnayak@ti.com,
        hvaibhav@ti.com, peter.ujfalusi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Tue, Sep 11, 2012 at 1:55 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
>> No major change from the previous version. Just removed the
>> omap-usb2 dt data and sent that as a separate patch.
>
> Well, I think you'd better keep them in the same series :-)
>
>> Rebased on
>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb
>
> Since it is DTS stuf, you should rebase that on top of the latest
> lo/devel-dt branch. All the latest DTS patches an in there for 3.7.

The ocp2scp data is not in linux-omap :-( And omap-usb2 has to be a
child of ocp2scp. So I used arm-soc tree to which ocp2scp stuff was
pulled into.
>
> While you are there, could you please rename the patches with "ARM: dts"
> prefix. It seems that this is the new convention :-)

Sure.

Thanks
Kishon
