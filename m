Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1AYNpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:45:25 -0500
Received: from service87.mimecast.com ([94.185.240.25]:33741 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753183Ab1AYNpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:45:24 -0500
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110123154607.GC30094@n2100.arm.linux.org.uk>
References: <20110114120229.GA15996@n2100.arm.linux.org.uk>
	 <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	 <20110114154919.GE15996@n2100.arm.linux.org.uk>
	 <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	 <20110114163520.GH15996@n2100.arm.linux.org.uk>
	 <1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
	 <20110114173050.GJ15996@n2100.arm.linux.org.uk>
	 <AANLkTin_pMzNc-ZL+rVcwaVawer0poyxhatqw5P-A2qW@mail.gmail.com>
	 <20110115154019.GF15996@n2100.arm.linux.org.uk>
	 <AANLkTim8OhAtqADck0Snq-7z7opw=coiQ4=DeO0O7Qa-@mail.gmail.com>
	 <20110123154607.GC30094@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Tue, 25 Jan 2011 13:45:13 +0000
Message-ID: <1295963113.10109.255.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 Jan 2011 13:45:18.0569 (UTC) FILETIME=[1A7CBD90:01CBBC96]
X-MC-Unique: 111012513452100601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-23 at 15:46 +0000, Russell King - ARM Linux wrote:
> So, here's the revised patch.  Ack?

Apart from the itttt instruction, it looks fine. So once we agree on
that, you can add my Ack.

-- 
Catalin


