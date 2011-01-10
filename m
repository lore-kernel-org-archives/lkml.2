Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1AJQGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:06:06 -0500
Received: from kroah.org ([198.145.64.141]:59644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab1AJQFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:05:22 -0500
Date: Mon, 10 Jan 2011 07:57:45 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 1/3] pci, usb: Seperate usb handoff func to another file
Message-ID: <20110110155745.GB5275@kroah.com>
References: <4D2A1152.1040903@kernel.org>
 <4D2A139A.6010108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2A139A.6010108@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 11:59:22AM -0800, Yinghai Lu wrote:
> 
> Make those func can take early, num, slot, func. So later could reuse them
> to do usb handoff much early.

As Ben pointed out, this isn't ok at all, sorry.

thanks,

greg k-h
