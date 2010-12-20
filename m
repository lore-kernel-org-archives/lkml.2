Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0LTPzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:55:14 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:65216 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab0LTPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:55:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TuoE8H6oOBTRiXDIpnarv61/4S3icoOBYaYzUHE4n7IqB3KHCGjgkTv38UtAS4EbuW
         b5DYqxF0/JBp7UHszyFXKp0Y438AieYdcbVCkTlYx6l6pR5HIlP/QaZe/Ka5E1vbU4N1
         6M9Md7TbNInOpoTZqvz+A1mOOUptAIbyAeQNk=
Message-ID: <4D0F7C5A.1060107@gmail.com>
Date: Mon, 20 Dec 2010 16:55:06 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe>	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>	 <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>	 <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe>	 <4D08CBF4.6040102@gmail.com> <1292460817.2323.465.camel@sli10-conroe>	 <20101216054620.GA3241@merkur.ravnborg.org>	 <1292479000.2323.468.camel@sli10-conroe>  <4D09E0EE.7040605@gmail.com> <1292808518.10593.8.camel@sli10-conroe>
In-Reply-To: <1292808518.10593.8.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/20/2010 02:28 AM, Shaohua Li wrote:
>> Not being able to cross build every arch is okay but you at least need
>> to make an effort to make things easily applicable to other archs and
>> avoid adding subtle ugliness like the above.  Please at least try to
>> look at other arch codes and see how things can be made to work across
>> different archs.  Setting up cross compilers for the major archs, for
>> example, sparc, power and ia64 isn't that difficult either.
>
> This still needs I fix every arch, for example, as Sam pointed out,
> spark build will fail. I really have the bandwidth and capability to do
> this. Increment changes are always preferred. My original patch is
> trying to follow increment changes way.

Yeah, well, in my experience, those approaches usually just end up
piling partial conversions on top of different set of partial
conversions.  It's not like we're talking about a major arch dependent
feature it's just a matter of looking through different arch codes,
maybe test building some, pushing things to linux-next and dealing
with fallouts if there is any.  I'll try to do it myself.

Thanks.

-- 
tejun
