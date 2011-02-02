Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1BBHZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:25:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10120 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1BBHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:25:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6244"; a="72676069"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Christoph Hellwig'" <hch@infradead.org>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1295595854-23232-1-git-send-email-tlinder@codeaurora.org> <20110121084729.GA12517@infradead.org>
In-Reply-To: <20110121084729.GA12517@infradead.org>
Subject: RE: [RFC/PATCH 1/4] uasp: MS UAS Protocol implementation - Infrastructure
Date: Wed, 2 Feb 2011 09:25:42 +0200
Message-ID: <003201cbc2aa$686046c0$3920d440$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acu5R9P09BrqEHfuQdGYwuLpzdRMhQJYODUg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Jan 21, 2011 at 09:44:13AM +0200, Tatyana Brokhman wrote:
> > This patch implements the infrastructure for the UASP function
> driver.
> > The UASP Function driver registers as a second configuration of the
> MS
> > Function driver.
> 
> We now have a proper scsi target infrastructure in drivers/target,
> please use it.
> 

Hi Christoph

Thank you for your input. Could you please specify the exact location of the
scsi target infrastructure you're referring to? Drivers/target is missing.
Also, if you could point me out to an example where this infrastructure is
used or any documentation on it, it would be very helpful.

Thanks,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




