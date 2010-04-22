Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0DVUDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:03:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758033Ab0DVUB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:56 -0400
Date: Thu, 22 Apr 2010 12:59:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, 563313@bugs.debian.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [165/197] ACPI: EC: Allow multibyte access to EC
In-Reply-To: <20100422190922.146928687@kvm.kroah.org>
Message-ID: <alpine.LFD.2.00.1004221257390.26046@i5.linux-foundation.org>
References: <20100422190922.146928687@kvm.kroah.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Apr 2010, Greg KH wrote:
> 
> From: Alexey Starikovskiy <astarikovskiy@suse.de>
> 
> commit dadf28a10c3eb29421837a2e413ab869ebd upstream

Hmm. Doesn't this need commit 2060c44576c79086ff24718878d7edaa7384a985
to fix things up for crazy access_bit_width values?

Maybe it's there in the series somewhere, but I didn't see it.

		Linus
