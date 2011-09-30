Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab1I3Wrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:47:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38161 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab1I3Wra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:47:30 -0400
Message-ID: <4E8646F8.8090109@zytor.com>
Date: Fri, 30 Sep 2011 15:47:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com
Subject: Re: [RFCv2][PATCH 1/4] break units out of string_get_size()
References: <20110930203219.60D507CB@kernel>  <4E8634D3.2080504@zytor.com> <1317422761.16137.669.camel@nimitz>
In-Reply-To: <1317422761.16137.669.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 03:46 PM, Dave Hansen wrote:
> 
> ... or the 'i' for that matter.
> 

The "i" you need in the array unless you want to say "500 iB" and the
like, or have special logic for it.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

