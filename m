Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2JIO5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:57:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:49649 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2JIO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:57:19 -0400
Message-ID: <50743B15.4020700@windriver.com>
Date: Tue, 9 Oct 2012 10:56:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Jonathan Nieder <jrnieder@gmail.com>, <stable@vger.kernel.org>,
        Ana Guerrero <ana@debian.org>, Willy Tarreau <w@1wt.eu>,
        Takashi Iwai <tiwai@suse.de>, Seth Heasley <seth.heasley@intel.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32.y, 2.6.34.y] ALSA: hda - ALSA HD Audio patch for
 Intel Panther Point DeviceIDs
References: <201104201059.57882.seth.heasley@intel.com>  <s5htydsiw20.wl%tiwai@suse.de> <20121009010734.GA24147@elie.Belkin> <1349747733.6336.19.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1349747733.6336.19.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-08 09:55 PM, Ben Hutchings wrote:
> On Mon, 2012-10-08 at 18:07 -0700, Jonathan Nieder wrote:
>> From: Seth Heasley <seth.heasley@intel.com>
>> Date: Wed, 20 Apr 2011 10:59:57 -0700
>>
>> commit d2edeb7c6f1dada8ca7d5c23e42d604e92ae0c76 upstream.
>>
>> This patch adds the HD Audio Controller DeviceIDs for the Intel Panther Point PCH.
>>
>> [jn: backported for 2.6.32.y by Ana Guerrero]
>>
>> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Tested-by: Ana Guerrero <ana@debian.org> # EliteBook 8570w
>> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
>> ---
>> Hi Willy and Paul,
>>
>> Please consider
>>
>>   d2edeb7c6f1d ALSA: hda - ALSA HD Audio patch for Intel Panther Point
>>                DeviceIDs
>>
>> for application to the 2.6.32.y and 2.6.34.y trees.
>>
>> It does what it says on the cover.  The patch was merged in the 3.0
>> cycle, so newer stable kernels don't need it.  Backported and
>> tested[1] against Debian's 2.6.32.y-based kernel by Ana (cc-ed) --
>> thanks!
>>
>> Thoughts of all kinds welcome, as always.
> [...]
> 
> I queued up a whole series of device ID updates for Debian stable, as
> they didn't obviously depend on other changes:
> 
> cea310e ALSA: hda_intel: ALSA HD Audio patch for Intel Patsburg DeviceIDs
> e35d4b1 ALSA: hda: add Vortex86MX PCI ids
> 0f0714c ALSA: hda - Add support for VMware controller
> d2edeb7 ALSA: hda - ALSA HD Audio patch for Intel Panther Point DeviceIDs

I found that d2edeb7c6f depends (only trivially, on context) on b686453543f,
which makes a blanket class for intel IDs so that "...the driver will work
with any new control chips in future."   In that respect, I guess it too
(b68645) is in the same class as the other "add more IDs" patches?

Paul.
--

> 
> (They can be cherry-picked cleanly in the above order.)  But if I've
> missed some post-2.6.32 dependencies then I would like to know.
> 
> Ben.
> 
