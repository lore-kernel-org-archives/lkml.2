Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0F1Mze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:55:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:38428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0F1Mzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:55:31 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] wmi: fix a memory leak in wmi_notify_debug
Date: Mon, 28 Jun 2010 14:55:28 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       platform-driver-x86@vger.kernel.org
References: <1277688645.22992.2.camel@mola>
In-Reply-To: <1277688645.22992.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281455.28599.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 June 2010 03:30:45 Axel Lin wrote:
> When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
> the caller must kfree the returned buffer if AE_OK is returned.
Oops, I forgot to free the buffer...
Thanks!

Matthew, can you queue this up, please.
It's a safe memleak fix (if wmi driver is loaded with debug_event=1).

Signed-off-by: Thomas Renninger <trenn@suse.de>

      Thomas
