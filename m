Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1F0Quz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:50:55 -0400
Received: from imr4.ericy.com ([198.24.6.8]:55861 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1F0Quw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:50:52 -0400
Subject: RE: [lm-sensors] coretemp: Support for Intel Atom E6XX CPU
 (TunnelCreek)?
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: Jean Delvare <khali@linux-fr.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654109E84A62C0@bgsmsx502.gar.corp.intel.com>
References: <201106271220.51953.alexander.stein@systec-electronic.com>
	 <20110627164108.777c2e28@endymion.delvare>
	 <1309191054.8271.636.camel@groeck-laptop>
	 <D6D887BA8C9DFF48B5233887EF04654109E84A62C0@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 27 Jun 2011 09:50:05 -0700
Message-ID: <1309193405.8271.645.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 12:40 -0400, R, Durgadoss wrote:
> Hi Guenter,
> 
> > I thought about replacing the manual TjMax detection code with code
> > using the model string to take care of problems like this - essentially
> > by providing a table with entries { model string, Tjmax } for each CPU
> > with Tjmax other than 100 degrees C. This way we could get rid of some
> > of the odd code we have today. Would that make sense ?
> 
> I completely agree with you here.
> This way, a lot of code in get_tjmax will be reduced, by just
> a search through some array.
>  
Unfortunately, looking at Alexander's /proc/cpuinfo output, it looks
like the E6xx chips have no mention of E6xx in the CPU ID string, which
unfortunately kills the idea. 

Do you know if there is _any_ means to distinguish E6xx from E6xxT ?

Thanks,
Guenter


