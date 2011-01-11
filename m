Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1AKBJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:09:00 -0500
Received: from kroah.org ([198.145.64.141]:35027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab1AKBIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:08:36 -0500
Date: Mon, 10 Jan 2011 17:07:39 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/4] x86, usb, pci: Disable usb legacy support early
Message-ID: <20110111010739.GC32585@kroah.com>
References: <4D2A1382.7010407@kernel.org>
 <4D2AC6BF.3010907@kernel.org>
 <4D2BA8FE.9090204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2BA8FE.9090204@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 04:49:02PM -0800, Yinghai Lu wrote:
> 
> Move quirks for usb handoff early for x86.
> 
> So we can get stable result when trying to calibrate apic timer with pm-timer.

I still fail to understand _why_ you are making these changes.

Exactly what problem do you currently have, on what hardware, that this
patch set solves?

confused,

greg k-h
