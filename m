Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab2JWOJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:09:50 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:10742 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2JWOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:09:49 -0400
Message-ID: <5086A52C.2030009@tilera.com>
Date: Tue, 23 Oct 2012 10:09:48 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] arch/tile: avoid build warnings from duplicate ELF_R_xxx
 #defines
References: <201210192039.q9JKdUE5003952@farm-0010.internal.tilera.com> <87vce3i4c4.fsf@rustcorp.com.au>
In-Reply-To: <87vce3i4c4.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 11:16 PM, Rusty Russell wrote:
> Chris Metcalf <cmetcalf@tilera.com> writes:
>
>> These are now provided in <asm-generic/module.h>, so clean up warning
>> by not re-defining them in module.c.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> This change was in linux-next for quite a while, BTW, so there would
> have been over a month of warnings...
>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks.  Yes, I don't always drill into the results of the builds at
http://kisskb.ellerman.id.au/kisskb/matrix/, but just go by the "Build OK"
green light.  I'll remember to keep looking at the details more frequently :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

