Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1D1Fxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:53:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62842 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1D1Fxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:53:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6329"; a="88068264"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>, "'USB list'" <linux-usb@vger.kernel.org>,
        "'Kernel development list'" <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
References: <20110426172559.GA5405@xanatos> <Pine.LNX.4.44L0.1104261423250.2035-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104261423250.2035-100000@iolanthe.rowland.org>
Subject: RE: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Date: Thu, 28 Apr 2011 08:54:48 +0300
Message-ID: <002701cc0568$cac33470$60499d50$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwEQXpp4qELhlrXQp6vIhbOVM00dgBImzuQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

> 
> Since Tanya is writing the gadget driver, she gets to decide how many
> streams it will support (limited by the device controller hardware).
> In this setting I would use one thread per stream, since a thread can't
> have more than one VFS read or write request outstanding at any time.
> 
> Except that, as Christoph has mentioned a few times, it would be better
> to abandon this driver design entirely and use the SCSI Target
> framework instead.  Then presumably threads would not be an issue.
> 
> Alan Stern

Thank you very much for you inputs and help! I'm not familiar with the SCSI
Target framework Christoph referred me too so I postponed looking into that
until the driver is stable. Well, I guess that time has come so I'll switch
over to studying that and applying it to the UAS gadget driver.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




