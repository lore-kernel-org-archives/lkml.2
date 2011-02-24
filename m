Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1BXQpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:45:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab1BXQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:45:52 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=dgxeImJIUbAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gIi8eh1RuD-OM48fK5gA:9 a=3GD2gb478Pu92ku-O5sA:7 a=ESapBTcUgUwymrjvM5GFnfxP7BAA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Feb 2011 11:45:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: git@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gitk with the latest branch makes the system unusable for some
 time
Message-ID: <20110224164551.GD888@home.goodmis.org>
References: <AANLkTim3MW0PmD5_tra4nmRapfgHJ9K_usJWGVK3AOUC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim3MW0PmD5_tra4nmRapfgHJ9K_usJWGVK3AOUC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

On Tue, Feb 22, 2011 at 03:53:08PM -0800, Justin Mattock wrote:
> not sure if there is any reports of this or not, basically using gitk
> on my macbookpro2,2 makes the system extremely slow and unusable
> (after a while can finally use the system)
> 
> in dmesg I am seeing this:
> 


> [ 6089.367430] [ 2593]  1000  2593    26616        1   1       0
>       0 bash
> [ 6089.367435] [ 2717]  1000  2717   326078   204267   0       0
>       0 wish
> [ 6089.367439] [ 2729]  1000  2729   141207     7349   0       0
>       0 git
> [ 6089.367444] Out of memory: Kill process 2717 (wish) score 802 or
> sacrifice child

Looks like a memory leak in gitk and nothing to do with the kernel. I
would take this up with them.

-- Steve

