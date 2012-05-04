Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2EDGcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:32:13 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:38919 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab2EDGcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:32:11 -0400
Message-ID: <4FA377E1.9060008@ti.com>
Date: Fri, 04 May 2012 12:02:01 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/7] Add TI EMIF SDRAM controller driver
References: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com> <CAP=VYLrCTOb9Qtz_HU5976cew_FR=qN6=x=_nD48ZprTcCjoUg@mail.gmail.com> <20120504000312.GB32225@kroah.com>
In-Reply-To: <20120504000312.GB32225@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012 05:33 AM, Greg KH wrote:
> On Thu, May 03, 2012 at 06:38:23PM -0400, Paul Gortmaker wrote:
>> On Fri, Apr 27, 2012 at 8:24 AM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:
>>> Add a driver for the EMIF SDRAM controller used in Texas Instrument SoCs
>>
>> Hi Santosh,
>>
>> Can you send Greg a patch that adds proper dependencies to the Kconfig?
>> I was going to simply add an ARM dependency, but perhaps you want to
>> restrict it further to a subset of OMAP platforms?
>>
Thanks Paul for reporting the issue.

>> At the moment it is causing build failures in other architectures.
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/6243036/
> 
> I think there's a config option for readl/writel, but yes, ARM would
> probably be fine as well.
> 
Just send a patch [1] to Greg. EMIF driver build is restricted to
ARCH_OMAP2PLUS for now and can be extended later if any other
non OMAP architecture start using it.

Regards
Santosh

[1] https://lkml.org/lkml/2012/5/4/22
