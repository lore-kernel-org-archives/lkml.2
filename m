Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab0HLBhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:37:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33295 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020Ab0HLBhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:37:45 -0400
Message-ID: <4C634FEF.1040503@zytor.com>
Date: Wed, 11 Aug 2010 18:35:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        gcosta@redhat.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de,
        ying.huang@intel.com
Subject: Re: + drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch
 added to -mm tree
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>	<20100811164310.a4790773.randy.dunlap@oracle.com> <20100811173327.3ae325ff.akpm@linux-foundation.org>
In-Reply-To: <20100811173327.3ae325ff.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 05:33 PM, Andrew Morton wrote:
> 
> Not very well.
> 
> +		rc = copy_from_user(&record_id, (void __user *)arg,
> +				    sizeof(u64));
> 
> better to use sizeof(record_id).
> 
> Where's Len??
> 
> Anyway, this should be fixed in x86 core, I suspect.

Agreed.  Looking at it now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

