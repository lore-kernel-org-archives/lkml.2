Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab0GVN5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:57:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44579 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488Ab0GVN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dyIwmMjqkPT6Jv0E07MuBRdm2Kq+JaIlJmvCDsnFpbgkJj/nc+hF3iO+5Xh6YORl90
         4Yor3UOrIJCeclIPuBkg/TxAQ+SO+cF+/8eVuptUZRwCWVhb3JgkaBmGuC1Ive/s3eLa
         o7yE/duytXo2c+BDCkO9rP18t9qaS1wWtgmns=
Message-ID: <4C484E41.50606@gmail.com>
Date: Thu, 22 Jul 2010 15:57:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: "Jin, Gordon" <gordon.jin@intel.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        Dave Airlie <airlied@redhat.com>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "eric@anholt.net" <eric@anholt.net>, Kees Cook <kees@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>
Subject: Re: i915 boot regression on Q35 chipset with 2.6.35-rc4
References: <4C46E98A.3010206@mail.tpi.com> <8u3s94$g0j0tc@orsmga002.jf.intel.com> <B32E3D5F1713054290B4FF257B89C51A1F1DAA512D@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <B32E3D5F1713054290B4FF257B89C51A1F1DAA512D@shsmsx502.ccr.corp.intel.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 11:19 AM, Jin, Gordon wrote:
> Chris Wilson wrote on Wednesday, July 21, 2010 9:37 PM:
>> On Wed, 21 Jul 2010 14:35:22 +0200, Tim Gardner <tcanonical@tpi.com>
>> wrote: 
>>> What's up with this patch? I haven't received any comment, nor has it
>>> appeared in your git repository.
>>
>> Dave hasn't taken it because it is a regression fix for i915 and the
>> current procedure is for those to go through Eric's tree. Eric has
>> been busy working on a new compiler for GLSL the last few weeks and
>> has been applying patches in batches.
>>
>> The patch I am happy to ack, but since I introduced the regression
>> [https://bugzilla.kernel.org/show_bug.cgi?id=16294], I'd rather have
>> someone more familiar with the intricacies of G33/G35/Q35 review it.
>>
>> For what is worth:
>> Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> This patch fixes the bug on our G33 (0x29b2).

FWIW works for me too.

And as this is present as of 35-rc1 upstream, this means almost 2 months
lag since the break till now. Could you guys sort this up ASAP, please?

thanks,
-- 
js
