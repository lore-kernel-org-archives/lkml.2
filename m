Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab0E0SWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:22:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:58748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0E0SWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:22:14 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527181758.GJ3543@srcf.ucam.org>
References: <20100527172510.GC2468@srcf.ucam.org>
	 <1274981288.27810.5609.camel@twins> <20100527173218.GF2468@srcf.ucam.org>
	 <1274981750.27810.5641.camel@twins> <20100527174140.GB3187@srcf.ucam.org>
	 <1274982397.27810.5679.camel@twins> <20100527175258.GB3543@srcf.ucam.org>
	 <1274982981.27810.5719.camel@twins> <20100527175920.GE3543@srcf.ucam.org>
	 <1274983598.27810.5761.camel@twins>  <20100527181758.GJ3543@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 20:22:08 +0200
Message-ID: <1274984528.27810.5818.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 19:17 +0100, Matthew Garrett wrote:

> It's blocked on the screen being turned off. It's supposed to be reading 
> a network packet. How does it ever get to reading the network packet?

Its blocked because its a buggy app, who cares about misbehaviour in a
buggy app?

If it were a proper app it wouldn't have gotten blocked and would've
been able to receive the network packet.

I thought we'd already been over this?


