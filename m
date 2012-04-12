Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab2DLOTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:19:17 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2280 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814Ab2DLOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:19:16 -0400
Message-ID: <1334240353.2222.3.camel@lorien2>
Subject: Re: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: shuahkhan@gmail.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Apr 2012 08:19:13 -0600
In-Reply-To: <1334170247.20190.34.camel@misato.fc.hp.com>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334161991.2226.18.camel@lorien2>
	 <1334170247.20190.34.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Shuah,
> 
> The fake _OST methods print arguments to verify successful execution of
> the methods.  Since the purpose of _OST is firmware-internal
> communication, there is no difference in testing on real firmware from
> the OS perspective.  Overriding DSDT with fake ACPI methods is a
> well-established and widely used testing method as well.

Toshi,

This patch hasn't gone through sufficient new functionality testing as
the only testing that was done was exercising it with stubbed out
firmware calls. I am not clear on how much regression testing this patch
has undergone. Sorry, it doesn't give me the warm and fuzzies.

-- Shuah


