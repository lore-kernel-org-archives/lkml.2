Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2DMPdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:33:10 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:35842 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2DMPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:33:08 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 11:33:08 EDT
Message-ID: <1334330617.2250.4.camel@lorien2>
Subject: Re: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Jiang Liu <liuj97@gmail.com>
Cc: shuahkhan@gmail.com, Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Apr 2012 09:23:37 -0600
In-Reply-To: <4F88371D.7030305@gmail.com>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334161991.2226.18.camel@lorien2>
	 <1334170247.20190.34.camel@misato.fc.hp.com>
	 <1334240353.2222.3.camel@lorien2> <4F88371D.7030305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 22:24 +0800, Jiang Liu wrote:
> Hi Shuah and Toshi,
> 	As I can tell, _OST method has been defined in ACPI4.0 spec and
> there are some platforms already implemented the _OST method. For example,
> Quanta QSSC-S4R server implements _OST for hot-pluggable PCI slots, but 
> it's a little pity that it doesn't implement _OST for the memory board,
> so we can't test Toshi's patch on that platform.
> 	According to my understanding, other than notifying BIOS about the
> event processing result, _OST could also be used to notify BIOS about the
> IN_PROGRESS state, so BIOS could track the event handling progress and avoid
> timeout. We have used _OST method to avoid timeout on one of our prototype
> platforms.

Thanks Jiang. This is good information about _OST method's timeout
use-case. Alos good to know there are platforms out there that already
implement it. Too bad you don't have any platforms to test Toshis's
patch. Maybe there are others that have one available.

-- Shuah


