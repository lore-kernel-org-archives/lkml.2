Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0LOG3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:29:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0LOG3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:29:08 -0500
Message-ID: <4D08602E.1040707@zytor.com>
Date: Tue, 14 Dec 2010 22:29:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Len Brown <lenb@kernel.org>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
References: <alpine.LFD.2.00.1012142317450.4878@x980>	<20101214220932.GA1206@sgi.com>	<alpine.LFD.2.00.1012141903210.25387@x980>	<20101215024136.GB19601@sgi.com>	<alpine.LFD.2.00.1012142302110.4878@x980> <acpi-map-cache-err@mdm.bga.com>
In-Reply-To: <acpi-map-cache-err@mdm.bga.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 10:17 PM, Milton Miller wrote:
> 
> after digging back through the thread for the patch, it would seem
> that both __acpi_map_table_permanent and e820_all_mapped would
> need to be moved from init to normal text, as this is replacing
> the non-init path.  I'll let the maintainers decide if that is the
> right solution (vs unconditonally mapping cached, or something else).
> 

Unconditionally map cached; filtering should be done in the PAT layer if
necessary.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

