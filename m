Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0LOWSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:18:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54940 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0LOWSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:18:54 -0500
Message-ID: <4D093EC3.7000308@zytor.com>
Date: Wed, 15 Dec 2010 14:18:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Jack Steiner <steiner@sgi.com>, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
References: <20101214220932.GA1206@sgi.com> <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com> <alpine.LFD.2.00.1012142302110.4878@x980> <20101215164635.GA27373@sgi.com> <alpine.LFD.2.00.1012151536510.21167@x980>
In-Reply-To: <alpine.LFD.2.00.1012151536510.21167@x980>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 01:16 PM, Len Brown wrote:
> 
> I'll bet we can improve the boot sequence so that
> some of the stuff we do before we have cached mappings
> we can do with cached mappings...
> We checksum all the tables, enumerate the CPUs and the APICs
> all using non-cached mappings....
> 

I don't think we have any reason to use uncached mappings, ever...

	-hpa
