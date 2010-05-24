Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0EXXUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:20:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:12322 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758557Ab0EXXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:20:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,294,1272870000"; 
   d="scan'208";a="520859391"
Message-ID: <4BFB09AF.80305@linux.intel.com>
Date: Mon, 24 May 2010 16:20:15 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [21/34] x86, amd: Check X86_FEATURE_OSVW bit before accessing
 OSVW MSRs
References: <20100524230351.224349120@clark.site>
In-Reply-To: <20100524230351.224349120@clark.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 03:59 PM, Greg KH wrote:
> 2.6.34-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Andreas Herrmann <herrmann.der.user@googlemail.com>
> 
> commit f01487119dda3d9f58c9729c7361ecc50a61c188 upstream.
> 

Also in 2.6.34...

	-hpa
