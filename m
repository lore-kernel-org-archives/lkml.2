Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2DBNDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:03:20 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:35601 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2DBNDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:03:18 -0400
Message-ID: <4F79A37D.5010605@googlemail.com>
Date: Mon, 2 Apr 2012 15:02:53 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, Matt Evans <matt@ozlabs.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [REGRESSION][PATCH V4 1/3] bpf jit: Make the filter.c::__load_pointer
 helper non-static  for the jits
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6ECE@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6ECE@saturn3.aculab.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Skim-SendBy: exchange.hs-owl.de on Mon, 02 Apr 2012 15:03:04 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Laight schrieb:
>  
>> The function is renamed to make it a little more clear what it does.
>> It is not added to any .h because it is not for general 
>> consumption, only for bpf internal use (and so by the jits).
> 
> I'd have thought it better to put in into a bfp_internal.h
> (or similar) with a big warning there about the asm users.
> 

Hmmm, OK, where would i put the .h? Right there under ./include/linux/?

> Possibly even worth adding some other defs that the asm
> files will need (if there are any).
> 

There is at least one other define, the lowest negative address range,
but it would be a copy of the same define in filter.h, or i would have
to massage filter.h to make it fit for inclusion by assembly.
So I'm unsure how to proceed.

> 	David
> 

Greetings
	Jan

-- 
An IPv4 address space walks into a bar: "A strong CIDR please. I'm
exhausted."
