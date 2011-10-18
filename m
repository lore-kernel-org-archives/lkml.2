Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1JRGEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:04:36 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:60514 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab1JRGEf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:04:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110141218240.19504@utopia.booyaka.com>
References: <1318319355-20168-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110131227270.24155@utopia.booyaka.com>
	<alpine.DEB.2.00.1110131857350.24155@utopia.booyaka.com>
	<CAP05o4JMnhd+59ocTw+z9a7ukSmDn1deL5T4D9q5ZeKw_tEg0w@mail.gmail.com>
	<alpine.DEB.2.00.1110141218240.19504@utopia.booyaka.com>
Date: Tue, 18 Oct 2011 11:34:31 +0530
Message-ID: <CAP05o4+uU66GteMU6sUS_GPoTZf-tDwn_tQ-9W-3hn5PvjZp+Q@mail.gmail.com>
Subject: Re: [PATCH 2/5 v14] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
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

On Fri, Oct 14, 2011 at 11:50 PM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi Keshava
>
> On Fri, 14 Oct 2011, Munegowda, Keshava wrote:
>
>> This updated patch is working perfectly on 3430 sdp.
>
> Great, thanks for testing this and the OMAP4 patch.  So, just FYI, I've
> pulled these patches into the branch 'usbhost_runtime_pm_14_devel_3.2' on
> git://git.pwsan.com/linux-2.6 - but I can't send these upstream until
> Samuel acks the MFD patch in this series.

Thanks Paul!  I request Samuel to ack on MFD patches.
Thanks a lot for helping me to complete the basic runtime pm adaptions.
