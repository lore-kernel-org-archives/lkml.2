Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1HCOkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:40:39 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:33021 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab1HCOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:40:32 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] coretemp: Support for Intel Atom E6XX CPU (TunnelCreek)?
Date: Wed, 3 Aug 2011 16:40:30 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: "R, Durgadoss" <durgadoss.r@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201106271220.51953.alexander.stein@systec-electronic.com> <201108031458.01805.alexander.stein@systec-electronic.com> <D6D887BA8C9DFF48B5233887EF04654109E88956B7@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654109E88956B7@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108031640.31196.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 03 August 2011 15:26:53 R, Durgadoss wrote:
> Yes I checked with some Atom Guys here.
> Apparently there is no way to know it from the OS Level.
> 
> > On Monday 27 June 2011 18:54:44 R, Durgadoss wrote:
> > > > Unfortunately, looking at Alexander's /proc/cpuinfo output, it looks
> > > > like the E6xx chips have no mention of E6xx in the CPU ID string,
> > > > which unfortunately kills the idea.
> > > > 
> > > > Do you know if there is _any_ means to distinguish E6xx from E6xxT ?
> > > 
> > > Sorry I do not know. But I can ask some folks here and get back
> > > to you guys. Should not take more time, once I identify the right
> > > person to ask :-)

So, is there a possibility to add a module parameter to force a either 
specific tjmax or the T model for E6xx?

Regards,
Alexander
