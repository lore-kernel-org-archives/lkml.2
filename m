Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1DPRSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 13:18:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15215 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab1DPRSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 13:18:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86008547"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Christoph Hellwig'" <hch@infradead.org>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>, "'Maya Erez'" <merez@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1302788149-27926-1-git-send-email-tlinder@codeaurora.org> <20110415041939.GB27928@infradead.org>
In-Reply-To: <20110415041939.GB27928@infradead.org>
Subject: RE: [RFC/PATCH v6 1/5] usb: Add streams support to the gadget framework
Date: Sat, 16 Apr 2011 20:19:36 +0300
Message-ID: <003701cbfc5a$78bd5000$6a37f000$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acv7JFOXv3pWEA/+Q6G/g6CZPlcWHQBNZvgQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph

At the moment we're not familiar with the SCSI target code you referred us
to. Since some learning is required in order to do as you suggested, we
thought that first we would like to have a full functional version of the
UAS gadget driver. Looking into the SCSI target code is in our TODO list, we
didn't ignore your inputs. On the contrary, we would appreciate more inputs
from you in the future. Thanks!

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, April 15, 2011 7:20 AM
> To: Tatyana Brokhman
> Cc: gregkh@suse.de; linux-arm-msm@vger.kernel.org;
> ablay@codeaurora.org; balbi@ti.com; Maya Erez; open list:USB
> GADGET/PERIPH...; open list
> Subject: Re: [RFC/PATCH v6 1/5] usb: Add streams support to the gadget
> framework
> 
> As I already told you before please do not create new SCSI target code
> that doesn't use the target core in drivers/target.  Thanks!


