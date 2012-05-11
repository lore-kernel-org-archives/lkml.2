Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab2EKPqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:46:16 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:52192 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760588Ab2EKPqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:46:14 -0400
Message-ID: <4FAD3443.40805@molgaard.org>
Date: Fri, 11 May 2012 17:46:11 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Firefox/15.0a1 SeaMonkey/2.12a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Boot failure since 3.3-rc?
References: <4F931C6D.8040407@molgaard.org> <4FA2BA49.3070902@molgaard.org>
In-Reply-To: <4FA2BA49.3070902@molgaard.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sune Mølgaard wrote:
> Incidentally, I had to swap a wifi card, and bisecting now leads to a
> different bad commit(?)
>
> This is what it says is the culprit now (I wonder if I should bisect
> again, and attempt booting maybe 3 or 4 times each time):
>
> f94edacf998516ac9d849f7bc6949a703977a7f3 is the first bad commit
> commit f94edacf998516ac9d849f7bc6949a703977a7f3

Would anyone happen to know if this has been backported to the 3.0-series?

Just tried booting the latest ubuntu 11.10 kernel (based on 3.0) which 
also failed. That should, naturally, be logged with the Ubuntu guys (and 
it will be), but until then, if someone can positively say that the 
above patch was backported, it might lend credence to the assumption 
that it is indeed the culprit.

I have, btw., ordered a small display to hook up to the machine in order 
to see where it fails.

Will report back...

Best regards,

Sune Mølgaard

-- 
First things first, but not necessarily in that order.
- Doctor Who


