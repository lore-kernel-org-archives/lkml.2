Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0E0RZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:25:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50629 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0E0RZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:25:34 -0400
Date: Thu, 27 May 2010 18:25:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527172510.GC2468@srcf.ucam.org>
References: <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk> <20100527161943.GA32764@srcf.ucam.org> <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain> <20100527170740.GA1980@srcf.ucam.org> <1274980391.27810.5552.camel@twins> <20100527171644.GA2468@srcf.ucam.org> <1274980856.27810.5582.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274980856.27810.5582.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:20:56PM +0200, Peter Zijlstra wrote:

> Suppose X (or whatever windowing system) will block all clients that try
> to draw when you switch off your screen.
> 
> How would we not wake them when we do turn the screen back on and start
> servicing the pending requests again?

How (and why) does the WoL (which may be *any* packet, not just a magic 
one) turn the screen back on?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
