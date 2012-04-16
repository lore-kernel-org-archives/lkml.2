Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2DPTrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:47:14 -0400
Received: from smtp3.su.se ([130.237.164.77]:47374 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752861Ab2DPTrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:47:12 -0400
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F8C773C.2010902@debian.org>
Date: Mon, 16 Apr 2012 21:47:08 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204160008.41104.rjw@sisk.pl> <1334529077.2092.1.camel@shrek.rexursive.com> <201204162038.38760.rjw@sisk.pl>
In-Reply-To: <201204162038.38760.rjw@sisk.pl>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-16 20:38, Rafael J. Wysocki skrev:
> On Monday, April 16, 2012, Bojan Smojver wrote:
>> On Mon, 2012-04-16 at 00:08 +0200, Rafael J. Wysocki wrote:
>>>> Signed-off-by: Per Olofsson <pelle@debian.org>
>>>
>>> Why signed-off? 
>>
>> Per contributed significantly to the development of the patch. In fact,
>> it was Per who noticed what the problem with number of free pages
>> calculation during hibernation actually was.
> 
> OK, but you wrote the patch in the end.
> 
> Reviewed-by from Per would be more appropriate.
> 
> Signed-off-by means as much as "I certify that am the author of this patch" or
> "This patch has gone through my hands and I know who the author is" (it implies
> "Acked-by" in the latter case).  None of these is the case here.

OK, let's say Reviewed-by then.

Reviewed-by: Per Olofsson <pelle@debian.org>

-- 
Pelle
