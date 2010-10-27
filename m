Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0J0RSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:18:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:54784 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0J0RSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,247,1286175600"; 
   d="scan'208";a="620871242"
Message-ID: <4CC85EE6.7030608@linux.intel.com>
Date: Wed, 27 Oct 2010 10:18:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
In-Reply-To: <4CC85839.4000507@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 9:50 AM, Jeremy Fitzhardinge wrote:
>
> This never used to be a problem.  Perhaps we can change how
> clone_pgd_range is used at boot time to avoid it in the Xen case (since
> we don't care about the secondary pagetable)?
>

Xen shouldn't have any users of this, since it's used for low-level 
operations like SMP bootstrap, suspend to RAM, reboot and low-level BIOS 
functionality.

	-hpa

