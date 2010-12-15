Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab0LOGRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:17:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46139 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab0LOGRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:17:40 -0500
Message-ID: <4D085D79.4010308@zytor.com>
Date: Tue, 14 Dec 2010 22:17:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Jack Steiner <steiner@sgi.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
References: <20101214220932.GA1206@sgi.com> <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com> <alpine.LFD.2.00.1012142302110.4878@x980> <alpine.LFD.2.00.1012142317450.4878@x980>
In-Reply-To: <alpine.LFD.2.00.1012142317450.4878@x980>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 08:35 PM, Len Brown wrote:
> 
> I'm not sure the concept of checking against E820
> is better than simply calling ioremap_cache() always.
> 

I don't think it is.  On most systems, non-RAM will be forced uncachable
by the MTRRs anyway, and if we find systems which have problems, we
should be doing this forcing in the PAT subsystem, not in ACPI.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

