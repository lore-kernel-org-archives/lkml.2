Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab0EXXNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:13:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759149Ab0EXXNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:13:37 -0400
Message-ID: <4BFB080F.3080508@zytor.com>
Date: Mon, 24 May 2010 16:13:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [20/34] x86, cacheinfo: Turn off L3 cache index disable feature
 in virtualized environments
References: <20100524230351.136502585@clark.site>
In-Reply-To: <20100524230351.136502585@clark.site>
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
> From: Frank Arnold <frank.arnold@amd.com>
> 
> commit 7f284d3cc96e02468a42e045f77af11e5ff8b095 upstream.
> 

Objection only that this already in 2.6.34.

	-hpa
