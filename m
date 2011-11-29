Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1K2TnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:43:03 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37217 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab1K2TnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:43:00 -0500
Message-ID: <4ED535A9.3070506@metafoo.de>
Date: Tue, 29 Nov 2011 20:42:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: Add patch to use kcalloc instead of kzalloc
 for array allocations
References: <1322232368-28814-1-git-send-email-lars@metafoo.de> <1322592151.1534.78.camel@localhost.localdomain>
In-Reply-To: <1322592151.1534.78.camel@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 07:42 PM, Thomas Meyer wrote:
> Am Freitag, den 25.11.2011, 15:46 +0100 schrieb Lars-Peter Clausen:
>> This patch adds a coccinelle patch to convert array allocations which use
>> kzalloc to kcalloc. The advantage of kcalloc is, that will take care of
>> integer overflows which could result from the multiplication and it is also
>> nicer to read.
> 
> Hi Lars,
> 
> I did run your kcalloc spatch against 3.2-rc3. are you okay with if I
> send the diffs to the LKML?
> 

Sure.

Thanks
- Lars
