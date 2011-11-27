Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1K0U1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 15:27:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45603 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1K0U1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 15:27:42 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Felipe Balbi <balbi@ti.com>, Li Yang <leoli@freescale.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: convert drivers/usb/* to use module_platform_driver()
References: <1322396187.2799.3.camel@phoenix>
Date: Sun, 27 Nov 2011 21:27:34 +0100
In-Reply-To: <1322396187.2799.3.camel@phoenix> (Axel Lin's message of "Sun, 27
	Nov 2011 20:16:27 +0800")
Message-ID: <87wralgvk9.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Axel" == Axel Lin <axel.lin@gmail.com> writes:

 Axel> This patch converts the drivers in drivers/usb/* to use the
 Axel> module_platform_driver() macro which makes the code smaller and a bit
 Axel> simpler.

 Axel> Cc: Peter Korsgaard <jacmet@sunsite.dk> 

For c67x00:

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
