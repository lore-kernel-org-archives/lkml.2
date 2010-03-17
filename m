Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0CQCYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:24:23 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:51953
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752130Ab0CQCYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:24:21 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KZEMOC-01-0CM-02
X-M-MSG: 
Date: Wed, 17 Mar 2010 10:22:28 +0800
From: Crane Cai <crane.cai@amd.com>
To: Alex Chiang <achiang@hp.com>
CC: greg@kroah.com, sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] USB: xhci: rename driver to xhci_hcd
Message-ID: <20100317022228.GB2138@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>,
	Alex Chiang <achiang@hp.com>, greg@kroah.com,
	sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20100316204845.GJ8278@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20100316204845.GJ8278@ldl.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Mar 2010 02:24:07.0458 (UTC) FILETIME=[EBB2A020:01CAC578]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 02:48:45PM -0600, Alex Chiang wrote:
> Naming consistency with other USB HCDs.

I don't know the value of this changes. 
I think we do not need to make this change, only make xhci.ko to xhci-hcd.ko.

Any way this depends on Sarah.

-- 
Best Regards,
- Crane

