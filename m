Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1LENXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:23:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab1LENXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:23:20 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Ku4o5zGfhUkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=SNDZXxBKDMv0wmJS9vQA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 00/11] [ANNOUNCE] 3.0.12-rt30-rc2
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
In-Reply-To: <201112051011.59858.tim.sander@hbm.com>
References: <20111204185444.411298317@goodmis.org>
	 <201112042113.37047.tim01@vlsi.informatik.tu-darmstadt.de>
	 <alpine.LFD.2.02.1112042145440.2735@ionos>
	 <201112051011.59858.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:23:18 -0500
Message-ID: <1323091398.30977.74.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 10:11 +0100, Tim Sander wrote:
> Hi 
> > Did some other time accounting increase instead ?
> Yes, the other time seemed to be increasing normally.
> 
> I should also point out, that this phenomen was not always happening, but only 
> sometimes and then again disapeared without any known reason.

Hmm, then are you sure that the tasklet patch causes the bug? Or perhaps
it only changes the timing to cause it. The bug may be without the patch
too.

-- Steve


