Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1C3PwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:52:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47525 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1C3PwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vhhAfi/NzykImovz8zl/cG3EUe98GC4ij8ASZNUHqnWP3nupolFTrmcxgyOzYs9DES
         nSAl8GWOACGihYWZEWe2l8PSjCbhXMk0nDMDNH99pLvs195h0EFVbcCjMJLJ+VzUcLDX
         p/rZ66uAqnHT6xE1RWEHM5cfP1bcP1zdXQMlA=
Message-ID: <4D9351AB.6080302@gmail.com>
Date: Wed, 30 Mar 2011 08:52:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>, trivial@kernel.org,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH]arch:Kconfig.locks Remove unused config option.
References: <1301416611-3651-1-git-send-email-justinmattock@gmail.com> <20110329175302.GF8529@home.goodmis.org> <20110330062258.GA2600@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20110330062258.GA2600@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 11:22 PM, Heiko Carstens wrote:
> On Tue, Mar 29, 2011 at 01:53:02PM -0400, Steven Rostedt wrote:
>> On Tue, Mar 29, 2011 at 09:36:51AM -0700, Justin P. Mattock wrote:
>>> using a cleanup script I found this, could be real/fake not sure
>>> I grepped the whole kernel and only found this. If/when you have
>>> time let me know..
>>
>> This was added by: 36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
>> mutex: have non-spinning mutexes on s390 by default
>>
>> and removed by: fa188ae1657d6edc7963d524ce9a0650fe725242
>> [S390] mutex: enable spinning mutex on s390
>>
>> So I think you are safe in removing it.
>
> Yes, that's just a leftover.
>

alright.. well I do see some others wouldn't mind give those a try as well.

>>
>>>
>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> Acked-by: Steven Rostedt<rostedt@goodmis.org>
>
> Acked-by: Heiko Carstens<heiko.carstens@de.ibm.com>
>

