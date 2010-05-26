Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0EZMgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:36:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58259 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0EZMgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:36:32 -0400
Date: Wed, 26 May 2010 15:35:32 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Florian Mickler <florian@mickler.org>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526123532.GA2629@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1274863655.5882.4875.camel@twins>
 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
 <1274867106.5882.5090.camel@twins>
 <20100526120242.5c9b73ad@schatten.dmk.lab>
 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
 <20100526133721.602633b2@schatten.dmk.lab>
 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
 <20100526142430.327ccbc4@schatten.dmk.lab>
 <20100526122932.GB1990@nokia.com>
 <20100526143323.7c6f8705@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100526143323.7c6f8705@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 May 2010 12:35:36.0773 (UTC) FILETIME=[F1264F50:01CAFCCF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 26, 2010 at 02:33:23PM +0200, ext Florian Mickler wrote:
>But then someone at the user side has to know what he is doing.
>
>I fear, if you target mass market without central distribution
>channels, you can not assume that much.

and that's enough to push hacks into the kernel ? I don't think so. Do 
it like apple and prevent multi-tasking for any non-apple applications 
:-p

-- 
balbi

DefectiveByDesign.org
