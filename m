Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1CNTEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:04:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1CNTEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:04:06 -0400
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=iMvQkSxJFt0A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0azM3ZO7AAAA:8 a=pGLkceISAAAA:8 a=pHpKwR-BsdsOJVXC6DYA:9 a=__QW53ICJKbZ0KmW36bp9ECYGjIA:4 a=CjuIK1q_8ugA:10 a=BGWj8ct6lkoA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 14 Mar 2011 15:04:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        greg@kroah.com, joe@perches.com, akpm@linux-foundation.org
Subject: Re: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
Message-ID: <20110314190404.GB20259@home.goodmis.org>
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
 <20110314113254.GA2761@gmail.com>
 <4D7E470E.8090204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7E470E.8090204@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 09:49:18AM -0700, H. Peter Anvin wrote:
> On 03/14/2011 04:32 AM, Harry Wei wrote:
> > On Sun, Mar 13, 2011 at 11:00:09PM +0100, Jesper Juhl wrote:
> >> I believe the return type of main should always be 'int'.
> >>
> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > Acked-by: Harry Wei <harryxiyou@gmail.com>
> 
> It would make more sense to rename the function to something other than
> main().

Right, maybe "boot_start"?

-- Steve

