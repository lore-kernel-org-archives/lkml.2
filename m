Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2GQWyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:54:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37283 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab2GQWyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:54:19 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-b3-5005ed1a83fc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, greg@kroah.com,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        jy0922.shim@samsung.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1342523006-8379-1-git-send-email-gautam.vivek@samsung.com>
 <1342523006-8379-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1342523006-8379-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH RESEND v4] USB: ehci-s5p: Add vbus setup function to the
 s5p ehci glue layer
Date: Wed, 18 Jul 2012 07:54:17 +0900
Message-id: <000601cd646f$18a86910$49f93b30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1kCcg0tjpHrZD3RausWpnKM6BZ6QAZSJgg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jAV2pt6wBBo3zOCwu75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBn/VuoXtDJX9K+YyNjAeICpi5GTQ0LARGLW6RYWCFtM
	4sK99WxdjFwcQgKLGCW+3z/MDOH8YpTY+gQkw8nBJqAm8eXLYXaQhIjALkaJA0smgFUxC/xk
	lLh+sBOqv5VR4tzXV8wgLZwCHhKPJz1iBbGFBZIkJh48BLacRUBVom3xXHYQm1fAVmLXmVlM
	ELagxI/J98COYhbQkli/8zgThC0vsXnNW6CZHEDHqks8+qsLEhYRMJI4cGIOVLmIxL4X7xgn
	MArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4LB+Jr2DcVWD
	xSFGAQ5GJR5ejnusAUKsiWXFlbmHGCU4mJVEeAWfA4V4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	mnh/9RcSSE8sSc1OTS1ILYLJMnFwSjUwOpbzqvBaT/v74sE8aV/PuLs18k/XzbA+/8rwlU/k
	xsIZO7sVmYyvnj8qcvZP9pxL8bcWvFLYY2oYUlNy5uJEhokCFcevLrvPYCbf4SCn/Pbgsgc8
	Dxe+5xRO/ZT54e0it7MfFL6cSay4/rwm9fInjbnpPvVO1YGXLC2e/NPh9DzRvi985+8bEUos
	xRmJhlrMRcWJAIDYZaZnAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 17, 2012 8:03 PM, Vivek Gautam wrote:
> 
> This patch retrieves and configures the vbus control gpio via
> the device tree. The suspend/resume callbacks will be later
> modified for vbus control.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>


