Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0FHRue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:50:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34239 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0FHRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iQOKaQIEdNDMA2SAgi4mpzly3ChqgED64iNEJx15vnnw/bAj7JlpWzw6Q7j7P1FWMD
         erewQkG1u1zgTYHoO+gd6aa837XWYSt3msFMwAhMrtt5CiePNMxz4lg1Rj2498Yjs2J6
         gGIyOBYXZQnueAYncj4ECZwTqAc2y5UIVFaNc=
Message-ID: <4C0E82E5.6010807@gmail.com>
Date: Tue, 08 Jun 2010 10:50:29 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]alsa:patch_realtek.c Add SSID table for MacBookAir2,1
References: <1275865793-7357-1-git-send-email-justinmattock@gmail.com> <s5h39wxk1p6.wl%tiwai@suse.de>
In-Reply-To: <s5h39wxk1p6.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 08:01 AM, Takashi Iwai wrote:
> At Sun,  6 Jun 2010 16:09:49 -0700,
> Justin P. Mattock wrote:
>>
>> This adds the SSID number to snd_pci_quirk for the
>> MacBookAir2,1 taken from codec#0 at:
>> http://launchpadlibrarian.net/49455483/Card0.Codecs.codec.0.txt
>> keep in mind I do not have one of these machines on hand
>> so please if you do have this machine please test for me..
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> I applied this one (after rearranging the quirk list order).
>
> Also the patch 3 and 5, both one-liner additions of a quirk, are
> applied, too, since they got tested somehow in bug reports.
>
> Could you rebase your changes for the proper MBA 1,1 and imac 7,1
> against the latest sound tree so that anyone can test them?  If they
> work better, then we can apply later your changes in addition.
>
>
> Thanks!
>
> Takashi


o.k. rebased these two against
the latest sound tree..noticed
a couple of messups which are fixed now
(Note to myself: when tired don't code)..

hopefully people test these and see..

cheers,

Justin P. Mattock
