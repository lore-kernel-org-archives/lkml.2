Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0LPLVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:21:55 -0500
Received: from lo.gmane.org ([80.91.229.12]:32985 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0LPLVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:21:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Bcache version 9
Date: Thu, 16 Dec 2010 03:21:33 -0800
Message-ID: <4D09F63D.8040406@gmail.com>
References: <20101121140808.GA6429@moria> <20101122010914.GB7688@kroah.com> <4CEB7648.8030000@gmail.com> <20101201041610.GA5891@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: c-76-105-220-120.hsd1.or.comcast.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
In-Reply-To: <20101201041610.GA5891@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 08:16 PM, Greg KH wrote:
> True, but I thought configfs could handle "bare" config items, you might
> want to look a bit closer as to how people are using it.  But I could be
> totally wrong however.

Just in case I wasn't the only one confused, I stared at the 
documentation and examples some more... still wasn't completely sure, so 
I wrote the code, and bare attributes without a configfs item do work. I 
just switched to configfs for the stuff that was in /sys/kernel/bcache, 
it'll be in the next version.

Almost got everything done on my todo list before it's ready to be 
submitted...

