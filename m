Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1AJQFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:05:23 -0500
Received: from kroah.org ([198.145.64.141]:59638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1AJQFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:05:21 -0500
Date: Mon, 10 Jan 2011 07:57:24 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 0/3] x86, usb, pci: Disable usb legacy support early
Message-ID: <20110110155724.GA5275@kroah.com>
References: <4D2A1382.7010407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2A1382.7010407@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 11:58:58AM -0800, Yinghai Lu wrote:
> move quirks for usb handoff early for x86.
> 
> So we can get stable result when trying to calibrate apic timer with pm-timer.

Is this a real problem today?  What is the symptom of the issue?  Where
was it reported as a problem?

thanks,

greg k-h
