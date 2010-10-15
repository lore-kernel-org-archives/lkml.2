Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab0JOW6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:58:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18683 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0JOW6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:58:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 15 Oct 2010 15:58:12 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "'Erik Gilling'" <konkers@google.com>, Greg KH <greg@kroah.com>
CC: Jon Mayo <jmayo@nvidia.com>, "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "olof@lixom.net" <olof@lixom.net>,
        "mcuos.com@gmail.com" <mcuos.com@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Fri, 15 Oct 2010 15:57:26 -0700
Subject: RE: [PATCH 1/1 V2] rtc: Add real-time clock driver for Tegra.
Thread-Topic: [PATCH 1/1 V2] rtc: Add real-time clock driver for Tegra.
Thread-Index: ActsvCp26VJQbnFwS+a3uIj8ndH7QwAABHkg
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BB82899B@HQMAIL03.nvidia.com>
References: <1287089791-25673-1-git-send-email-achew@nvidia.com>
	<AANLkTim1LQ5xE9fxT9JgKb4a7AKsnRF+3daHcSGBKK4O@mail.gmail.com>
	<20101015223501.GA18609@kroah.com>
 <AANLkTi=-DVhrzvwq_u5LBdshF8S71ike_LTwiwoaXb8F@mail.gmail.com>
In-Reply-To: <AANLkTi=-DVhrzvwq_u5LBdshF8S71ike_LTwiwoaXb8F@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> This is kinda odd.  Usually when doing work on behalf of 
> the company
> >> you work for, the code is (c) the company.  Consider changing Jon's
> >> line to "Author: Jon Mayo <jmayo@nvidia.com>"
> >
> > Woah, are you sure?  Some companies, and countries, 
> allow/require dual
> > copyright.  The only one who can change this for sure is 
> Jon, not anyone
> > else.
> 
> I stand corrected.  However, I have yet to see a Tegra patch from
> nvidia that lists any author name, copyright or no.  Jon, can you
> clarify?

I've already corrected this (see V3 of this patch).  I removed Jon from the top comment block, and put him instead into MODULE_AUTHOR.