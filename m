Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2ICDPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:15:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2ICDPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:15:15 -0400
Message-ID: <504420B9.2020601@canonical.com>
Date: Mon, 03 Sep 2012 11:15:05 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
References: <1346319009.951368.767015086462.1.gpush@pecola> <503FA15F.7070506@zytor.com> <50400859.2080606@canonical.com> <5e40036f-b0da-47f3-acba-5dea9fdb7ed6@email.android.com> <50440A5A.900@canonical.com> <9741b1ed-c285-4f89-b60d-337140194345@email.android.com>
In-Reply-To: <9741b1ed-c285-4f89-b60d-337140194345@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,

> Well, appending is an action, not really a property of the variable
> that sticks around, no?

True, but they're still all defined as the same thing in the UEFI spec.
If you're looking to define which attributes to pass, you now need to
know the extra information that you pass most of the SetVariable()
attributes through the filename, but APPEND_WRITE is passed a completely
different way.

To me, this sounds fairly non-intuitive for a developer to discover.

Cheers,


Jeremy
