Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2KPWCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:02:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60946 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2KPWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:02:38 -0500
Date: Fri, 16 Nov 2012 23:02:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/8] x86/acpi: Use __pa_symbol instead of __pa on C
 visible symbols
Message-ID: <20121116220253.GA2681@elf.ucw.cz>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
 <20121116215737.8521.51167.stgit@ahduyck-cp1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116215737.8521.51167.stgit@ahduyck-cp1.jf.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2012-11-16 13:57:43, Alexander Duyck wrote:
> This change just updates one spot where __pa was being used when __pa_symbol
> should have been used.  By using __pa_symbol we are able to drop a few extra
> lines of code as we don't have to test to see if the virtual pointer is a
> part of the kernel text or just standard virtual memory.
> 
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>

ACK.
