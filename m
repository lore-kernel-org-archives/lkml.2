Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1JDLy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 07:54:26 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48843 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994Ab1JDLyY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 07:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109301259570.12185@utopia.booyaka.com>
References: <1317306247-1103-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109301259570.12185@utopia.booyaka.com>
Date: Tue, 4 Oct 2011 17:24:23 +0530
Message-ID: <CAP05o4+AQee0dJdiU9gaTcSh6vMX=qRd9prtqPN_n=SpW-cWgQ@mail.gmail.com>
Subject: Re: [PATCH 0/5 v12] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 12:31 AM, Paul Walmsley <paul@pwsan.com> wrote:
>
> Hi Keshava,
>
> by the way, when you repost these, can you split this into two series --
> one for the arch/arm/*omap* changes, and the other for changes that should
> go in through the MFD tree?  Then just note in the second series that it
> has a dependency on the first.  That will make it easier to merge these
> patches, and should cut down on the number of cc's that are necessary for
> most of these patches.

so, only patch 5 will be out this existing series;
1-4 will be one series and only patch 5 will be sent as a separate patch.

regards
keshava
