Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0FXNUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:20:23 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56594 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0FXNUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:20:21 -0400
Date: Thu, 24 Jun 2010 15:20:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       mauro@elte.hu
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624132032.GA4474@kryptos.osrc.amd.com>
References: <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
 <20100624123537.GA28884@elte.hu>
 <20100624130234.GM578@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624130234.GM578@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Thu, Jun 24, 2010 at 03:02:34PM +0200

> On Thu, Jun 24, 2010 at 02:35:37PM +0200, Ingo Molnar wrote:
> > All of these solutions use the fact that perf events are a generic event 
> > framework. If there's any missing details somewhere then fixes/enhancements 
> > can be added - right now our in-kernel event consumers are simple. But the 
> > design is sound.
> 
> One immediate problem that comes to mind with the proposal 
> is that if the event is of a type that cannot be dropped (e.g. an error 
> that needs to be handled) then a shared ring buffer cannot guarantee that.

If its a critical error you do all the handling in the kernel and you
don't need task context at all, no? Can you give an example of such an
error?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
