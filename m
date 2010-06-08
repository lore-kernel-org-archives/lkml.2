Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0FHSLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:11:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36084 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab0FHSLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:11:46 -0400
Message-ID: <4C0E87BB.4050303@zytor.com>
Date: Tue, 08 Jun 2010 11:11:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>	<m1631ue5ho.fsf@fess.ebiederm.org>	<4C0D8F43.4070900@zytor.com> <20100608091012.034f1cca@lxorguk.ukuu.org.uk>
In-Reply-To: <20100608091012.034f1cca@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 01:10 AM, Alan Cox wrote:
>>> You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
>>> irqs 0-15 are the ISA irqs you may not use those irq numbers for
> 
> Linux IRQ 0 is "no IRQ assigned", except buried in certain bits of arch
> specific historical knowledge.
> 
> Also calling 1-15 ISA IRQ lines is also somewhat misleading given they
> are almost certainly routing for PCI devices. "PIC IRQ routing" maybe -
> but even that is not really true on a lot of PC hardware today except by
> convention.

Yes, but I gather IRQ/GSI 0 is an early-acquire primary timer on MRST on
Moorestown just as on PC/AT... just a different one.  Hence "special" in
the same sort of way.  I don't really care, personally, though.

	-hpa

