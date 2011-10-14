Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1JNSUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:20:37 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:51027 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1JNSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:20:36 -0400
Date: Fri, 14 Oct 2011 12:20:35 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v14] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4JMnhd+59ocTw+z9a7ukSmDn1deL5T4D9q5ZeKw_tEg0w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110141218240.19504@utopia.booyaka.com>
References: <1318319355-20168-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110131227270.24155@utopia.booyaka.com> <alpine.DEB.2.00.1110131857350.24155@utopia.booyaka.com> <CAP05o4JMnhd+59ocTw+z9a7ukSmDn1deL5T4D9q5ZeKw_tEg0w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava

On Fri, 14 Oct 2011, Munegowda, Keshava wrote:

> This updated patch is working perfectly on 3430 sdp.

Great, thanks for testing this and the OMAP4 patch.  So, just FYI, I've 
pulled these patches into the branch 'usbhost_runtime_pm_14_devel_3.2' on 
git://git.pwsan.com/linux-2.6 - but I can't send these upstream until 
Samuel acks the MFD patch in this series.


- Paul
