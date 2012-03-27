Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2C0GTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 02:19:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35515 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2C0GTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 02:19:19 -0400
Message-ID: <4F715BCF.8050808@zytor.com>
Date: Mon, 26 Mar 2012 23:18:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240402.38749.trenn@suse.de> <4F6D50DD.4050306@zytor.com> <201203260245.43177.trenn@suse.de> <4F6FC57D.3050404@zytor.com> <20120327044643.18911.qmail@stuge.se>
In-Reply-To: <20120327044643.18911.qmail@stuge.se>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 09:46 PM, Peter Stuge wrote:
> H. Peter Anvin wrote:
>> There are a lot of bootloaders, and one of the most commonly used ones
>> has a very adversarial relationship with the kernel maintainers.
> 
> A couple of less commonly used ones, by or near the coreboot project,
> haven't exactly been embraced by kernel maintainers. Dunno if it's
> because coreboot doesn't much like ACPI, and thinks that it would
> be interesting to explore and innovate firmware on x86.
> 
> //Peter

I think it is more because coreboot has tried to do things in
nonstandard ways rather than fill in the gaps they have.  This is
getting a *lot* better, as far as I can tell, but in a sane world there
shouldn't be any need for "bootloaders by or near the coreboot project"
since any standard x86 bootloader should Just Work[TM].

I like to draw parallels with how we dealt with holes in applications in
the early days of Linux.  For example, when Linux wasn't providing the
interfaces that X needed, we didn't add a bunch of Linux-specific code
to X, *we added the standard interfaces to Linux*.

	-hpa
