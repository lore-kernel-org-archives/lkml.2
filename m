Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0ENQyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:54:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39727 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0ENQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bP0KmQVgxl191JIiVZfFUBTLk/ArdfebA2iyBWdjFsL9l1SGgBupSPwki6ebN9BiAn
         6xSov2GztqMyIwDEzyBylAKebuE7R0Y6MqcG8wameEc4U0RlDbHcQ5IuKid4Mfde8Xt/
         p6rkdFwgBhK8fBLGphPOtUd5nPs6cdzboYEWg=
Message-ID: <4BED8043.9070300@gmail.com>
Date: Fri, 14 May 2010 09:54:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>  <AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com> <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com> <4BECDD5D.9010609@gmail.com> <alpine.DEB.2.00.1005141110100.9466@router.home>
In-Reply-To: <alpine.DEB.2.00.1005141110100.9466@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/10 09:12, Christoph Lameter wrote:
> On Thu, 13 May 2010, Justin P. Mattock wrote:
>
>> I enable these options as well..
>> (then see If I can(hopefully)re-create this
>> then I'll bisect it).
>
> Debugging causes a slowdown. You can switch debuggin on for a specific
> slab.
>
> f.e.
>
> slub_debug=,kmalloc-8192
>
> See also Documentation/vm/slub.txt
>
>

Cool, thanks for this.. I'll have a look
also in slub.txt as well(never really did much
debugging with slub).

Justin P. Mattock
