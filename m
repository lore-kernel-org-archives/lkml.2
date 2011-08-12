Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1HLXwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:52:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53979 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1HLXwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:52:45 -0400
Message-ID: <4E45BCBA.2050703@gmail.com>
Date: Fri, 12 Aug 2011 16:52:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: i915 suspend crash: BUG: unable to handle kernel NULL pointer
 deferrence
References: <4E44C537.8040101@gmail.com> <yunobzusona.fsf@aiko.keithp.com> <4E454D75.2090505@gmail.com> <yunliuysgf6.fsf@aiko.keithp.com> <4E4564D0.70104@gmail.com> <yund3gaseyl.fsf@aiko.keithp.com>
In-Reply-To: <yund3gaseyl.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 10:43 AM, Keith Packard wrote:
> On Fri, 12 Aug 2011 10:37:20 -0700, "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>>    I have: Enable modesetting on intel by default (DRM_I915_KMS) not set
>>    in my .config. I will enable that and see if this fixes this issue, if
>> not then I will test those patches out.
>
> Could you test the patches without switching to KMS first? Otherwise,
> the underlying bugs aren't going to get fixed for anyone else...
>

Thanks a who lot for that.. machine wakes up perfectly with that patch..

dmesg of a patch applied with a good wakeup:

http://fpaste.org/7GA7/

only really thing now I am seeing is:
[drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
[ 146.362007] render error detected, EIR: 0x00000010
[ 146.362007] page table error

but might just be cosmetic.

Justin P. Mattock
