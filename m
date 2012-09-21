Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab2IUTAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:00:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65075 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab2IUTAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:00:40 -0400
Message-ID: <505CB94E.2040100@kernel.org>
Date: Fri, 21 Sep 2012 15:00:30 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv3 4/4] efi: Fix the ACPI BGRT driver for images located
 in EFI boot services memory
References: <cover.1347141698.git.josh@joshtriplett.org> <ced9fa2da63a605cdd905f3e75d7e0bd33a2011d.1347141698.git.josh@joshtriplett.org>
In-Reply-To: <ced9fa2da63a605cdd905f3e75d7e0bd33a2011d.1347141698.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for drivers/acpi/

Acked-by: Len Brown <len.brown@intel.com>

As this is mostly an EFI thing, I assume HPA is handling this series.

-Len Brown, Intel Open Source Technology Center

