Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2DMSex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:34:53 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:27223 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2DMSev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:34:51 -0400
Message-ID: <1334342089.3422.5.camel@lorien2>
Subject: Re: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: shuahkhan@gmail.com, Jiang Liu <liuj97@gmail.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Apr 2012 12:34:49 -0600
In-Reply-To: <1334333152.20190.85.camel@misato.fc.hp.com>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334161991.2226.18.camel@lorien2>
	 <1334170247.20190.34.camel@misato.fc.hp.com>
	 <1334240353.2222.3.camel@lorien2> <4F88371D.7030305@gmail.com>
	 <1334330617.2250.4.camel@lorien2>
	 <1334333152.20190.85.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I would like to explain more detail about my testing.  Unlike other ACPI
> methods, the functionality of _OST method is not defined by the spec.
> It is all up to the firmware implementation.  

A good reason why this patch requires more testing than on simulated
firmware code that is based on one single firmware implementation.

-- Shuah

