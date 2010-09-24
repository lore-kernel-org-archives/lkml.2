Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0IXNst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:48:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab0IXNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:48:47 -0400
X-User-Agent: K-9 Mail for Android
References: <19611.16302.262307.129176@pilspetsen.it.uu.se> <20100923113807.4643fbbb.rdunlap@xenotime.net> <19611.46496.782340.466509@pilspetsen.it.uu.se> <20100923150559.9c67da11.rdunlap@xenotime.net> <20100924111209.3c071da3@endymion.delvare> <19612.33369.175358.879889@pilspetsen.it.uu.se> <20100924133932.4320b993@endymion.delvare>
In-Reply-To: <20100924133932.4320b993@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUG 2.6.36-rc5] of_i2c.ko <-> i2c-core.ko dependency loop
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 24 Sep 2010 07:48:38 -0600
To: Jean Delvare <khali@linux-fr.org>, Mikael Pettersson <mikpe@it.uu.se>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Message-ID: <f1f37e21-f04a-4fef-868c-27c7d2ebe594@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Jean Delvare" <khali@linux-fr.org> wrote:

>Hi Mikael,
>
>On Fri, 24 Sep 2010 12:50:01 +0200, Mikael Pettersson wrote:
>> Jean Delvare writes:
>>  > As far as I can see this is caused by this commit from Grant:
>>  > 
>>  > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=959e85f7751c33d1a2dabc5cc3fe2ed0db7052e5
>>  > 
>>  > Mikael, can you please try reverting this patch and see if it solves
>>  > your problem?
>> 
>> Yes, reverting the above commit from 2.6.36-rc5 eliminated the warnings,
>> and I was able to insmod the i2c-{core,dev,powermac}.ko modules.
>
>Thanks for testing and reporting. Grant, unless you come up with a fix
>very quickly, I'll have to revert
>959e85f7751c33d1a2dabc5cc3fe2ed0db7052e5 for 2.6.36.

I'll get a fix out today.
g.

>
>-- 
>Jean Delvare

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
