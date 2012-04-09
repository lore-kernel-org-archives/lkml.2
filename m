Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab2DIVnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:43:22 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40481 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2DIVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:43:20 -0400
Date: Mon, 9 Apr 2012 14:43:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: fix memory leak
Message-ID: <20120409214316.GB535@kroah.com>
References: <1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <d858d87f-6e07-4303-a9b3-e41ff93c8080@default>
 <4F7C7626.40506@linux.vnet.ibm.com>
 <4F83454A.3050007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F83454A.3050007@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Mon, Apr 09, 2012 at 03:23:38PM -0500, Seth Jennings wrote:
> Hey Greg,
> 
> Haven't heard back from you on this patch and it needs to
> get into the 3.4 -rc releases ASAP.  It fixes a substantial
> memory leak when frontswap/zcache are enabled.
> 
> Let me know if you need me to repost.
> 
> The patch was sent on 4/2.

5 meager days ago, with a major holliday in the middle, not to mention a
conference as well.  That's bold.

It is not lost, is in my queue, and will get to Linus before 3.4-final
comes out, don't worry.

greg k-h
