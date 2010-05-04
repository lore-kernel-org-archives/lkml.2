Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517Ab0EDWyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:54:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843Ab0EDWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:54:22 -0400
Date: Tue, 4 May 2010 15:53:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>, Myron Stowe <myron.stowe@hp.com>
Subject: Re: [PATCH 1/8] ipmi: Change addr_source to an enum rather than
 strings
Message-Id: <20100504155356.57722519.akpm@linux-foundation.org>
In-Reply-To: <20100503133331.GA8130@minyard.local>
References: <20100503133331.GA8130@minyard.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I already have three IPMI patches queued:

http://userweb.kernel.org/~akpm/mmotm/broken-out/ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

The first two were repairable.  The third is now thoroughly trashed and
needs redoing.

I have no record of you having reviewed or [n]acked those three IPMI
patches?

