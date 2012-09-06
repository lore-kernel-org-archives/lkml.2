Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2IFRHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:07:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46071 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759132Ab2IFRHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:07:20 -0400
Message-ID: <5048D83D.8000408@zytor.com>
Date: Thu, 06 Sep 2012 10:07:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Jan Beulich <JBeulich@suse.com>, Vasco Dias <rafa.vasco@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cJ-ko@zougloub.eu
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI calls
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>  <5048D09A020000780009965B@nat28.tlf.novell.com> <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone care to refresh my memory why we can't use the "global" 
1:1+kernel map, possibly with some improvements (which would benefit the 
users of those maps too)?  With that I mean initial_page_map on i386 and 
trampoline_pgd on x86-64...

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

