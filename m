Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0EZMaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:30:00 -0400
Received: from smtp.nokia.com ([192.100.122.233]:36349 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0EZM36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:29:58 -0400
Date: Wed, 26 May 2010 15:29:32 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Florian Mickler <florian@mickler.org>
Cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526122932.GB1990@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <87wrusvrqe.fsf@deeprootsystems.com>
 <201005250138.16293.rjw@sisk.pl>
 <1274863655.5882.4875.camel@twins>
 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
 <1274867106.5882.5090.camel@twins>
 <20100526120242.5c9b73ad@schatten.dmk.lab>
 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
 <20100526133721.602633b2@schatten.dmk.lab>
 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
 <20100526142430.327ccbc4@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100526142430.327ccbc4@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 May 2010 12:29:36.0358 (UTC) FILETIME=[1A535860:01CAFCCF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Wed, May 26, 2010 at 02:24:30PM +0200, ext Florian Mickler wrote:
>And if you have two kernels, one with which your device is dead after 1
>hour and one with which your device is dead after 10 hours. Which would
>you prefer? I mean really... this is ridiculous.

What I find ridiculous is the assumption that kernel should provide good 
power management even for badly written applications. They should work, 
of course, but there's no assumption that the kernel should cope with 
those applications and provide good battery usage on those cases.

You can install and run anything on the device, and they will work as 
they should (they will be scheduled and will be processed) but you can't 
expect the kernel to prevent that application from waking up the CPU 
every 10 ms simply because someone didn't think straight while writting 
the app.

-- 
balbi

DefectiveByDesign.org
