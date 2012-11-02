Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab2KBBKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:10:13 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:50359 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2KBBKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:10:10 -0400
Message-ID: <50931D6D.2080402@cc.hut.fi>
Date: Fri, 02 Nov 2012 03:10:05 +0200
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: urandom is too slow
References: <508FEA5A.7010406@cc.hut.fi> <20121030185403.GA5044@thunk.org> <20121030213850.7b987ddf@pyramind.ukuu.org.uk>
In-Reply-To: <20121030213850.7b987ddf@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.10.2012 23:38, Alan Cox wrote:
> If you want to wipe a disk issue a security erase command via hdparm. 
> There is no guarantee that simply writing crap all over it will re-use 
> the same sectors of physical media, and for a flash drive it causes 
> massive wear and takes forever while a security erase is normally near 
> immediate. Alan 

Thank you for your answers, they should be very helpful for someone who 
is actually blanking or shredding their disks. However, I am just 
genuinely interested on why is no better CSPRNG algorithm used in the 
kernel (is it simply because no-one sent a patch or am I missing 
something?).

