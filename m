Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1D1CnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:43:04 -0400
Received: from mail.tpi.com ([70.99.223.143]:4329 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1D1CnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:43:03 -0400
Message-ID: <4DB8D429.5010203@canonical.com>
Date: Wed, 27 Apr 2011 20:42:49 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, wwguy <wey-yi.w.guy@intel.com>
CC: Andi Kleen <ak@linux.intel.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
References: <20110426212.641772347@firstfloor.org> <20110426211418.AF9B93E1886@tassilo.jf.intel.com> <4DB85596.4070105@canonical.com> <38255.1303937247@localhost> <4DB896B5.7090506@linux.intel.com> <1303943578.22777.32.camel@wwguy-ubuntu> <20110427224125.GR16484@one.firstfloor.org> <1303944143.22777.35.camel@wwguy-ubuntu> <20110427224659.GS16484@one.firstfloor.org>
In-Reply-To: <20110427224659.GS16484@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 04:46 PM, Andi Kleen wrote:
>> The current driver behavior, try to load the maximum version first, if
>> does not exist, then fall back to the older version. This patch just
>> increase the maximum API version to "5", so driver will try to load the
>> version "5" first.
>
> Okay thanks for the explanation. I will keep this patch then.
>
> -Andi

I'm good with that. Thanks Wey.

-- 
Tim Gardner tim.gardner@canonical.com
