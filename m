Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1AJIoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:44:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17617 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1AJIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:44:07 -0500
Message-ID: <4D2AC6BF.3010907@kernel.org>
Date: Mon, 10 Jan 2011 00:43:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 0/4] x86, usb, pci: Disable usb legacy support early
References: <4D2A1382.7010407@kernel.org>
In-Reply-To: <4D2A1382.7010407@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move quirks for usb handoff early for x86.

So we can get stable result when trying to calibrate apic timer with pm-timer.

-v2: according to BenH, keep pci_dev *pdev with those quirk function.

Thanks

Yinghai Lu

