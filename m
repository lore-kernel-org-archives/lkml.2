Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab1FKPdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:33:14 -0400
Received: from mta11.charter.net ([216.33.127.80]:54049 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab1FKPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:33:13 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=p9YancsnzTcA:10 a=bwGQv-0rnx0A:10 a=IkcTkHD0fZMA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=ri_HjeljxYTFM4iTPxwA:9 a=QEXdDO2ut3YA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF38AB8.4080004@cuw.edu>
Date: Sat, 11 Jun 2011 10:33:12 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Nicolas Palix <Nicolas.Palix@inria.fr>
CC: julia@diku.dk, rdunlap@xenotime.net, Gilles.Muller@lip6.fr, cocci@diku.dk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] coccicheck: add M= option to control which dir is
 processed
References: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu>	<1307503774-30370-2-git-send-email-Gregory.Dietsche@cuw.edu>	<4DEFC6DA.9050809@cuw.edu> <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com>
In-Reply-To: <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 02:10 PM, Nicolas Palix wrote:
> I am not familiar with out-of-tree development but I guess that in
> that case we should
> also add a "-I $KBUILD_EXTMOD/include" ?
>
>    
I decided to skip doing this in V2 of the patch. I did a very quick test 
and cocci didn't seem to like two -I flags on one command line.
> The use of -I by Coccinelle depends on the other options (like
> -include_headers or -all_includes).
> Such options are retrieved from the comments in the cocci files.
> So the need for -I depends on the semantic patch you consider. I think
> it is thus better
> to be "exhaustive" in that case.
>
> Julia, is there any performance problem in doing so ?
>    

Greg

