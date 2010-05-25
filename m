Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0EYPxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:53:12 -0400
Received: from kroah.org ([198.145.64.141]:50183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0EYPxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:53:10 -0400
Date: Tue, 25 May 2010 08:53:07 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@CS.Princeton.EDU>
Cc: stable@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere
 EP)
Message-ID: <20100525155307.GA7453@kroah.com>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:10:28AM -0400, "S.Çağlar Onur" wrote:
> Hi,
> 
> We are observing boot failures [1] & [2] on some of our servers (Dell
> r410) with 2.6.27-stable kernels. I found following commit in upstream
> tree via a quick search (but I haven't tried it yet) so I don't know
> whether I'm on the right track or not. 
> 
> Please let me know if anything else is needed...

Has any .27 kernel worked on these machines?  If so, can you narrow it
down to the patch that caused the problem?

thanks,

greg k-h
