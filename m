Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab1D1ONl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:13:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58284 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759730Ab1D1ONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:13:40 -0400
Date: Thu, 28 Apr 2011 10:13:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <gregkh@suse.de>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>, "'USB list'" <linux-usb@vger.kernel.org>,
        "'Kernel development list'" <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
Subject: RE: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
In-Reply-To: <002701cc0568$cac33470$60499d50$@org>
Message-ID: <Pine.LNX.4.44L0.1104281007120.2108-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011, Tanya Brokhman wrote:

> Thank you very much for you inputs and help! I'm not familiar with the SCSI
> Target framework Christoph referred me too so I postponed looking into that
> until the driver is stable. Well, I guess that time has come so I'll switch
> over to studying that and applying it to the UAS gadget driver.

I'm not familiar with that framework either, so if you find any good
introductory documentation (other than the files in
Documentation/target) please post a link to it.  Nicholas Bellinger is
very willing to answer questions.

Alan Stern

