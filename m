Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0HZAHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:07:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43013 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab0HZAHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:07:11 -0400
Message-ID: <4C75AFFC.5090601@zytor.com>
Date: Wed, 25 Aug 2010 17:06:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
References: <20100825094925.GA3632@pema> <20100825161214.GA15087@rhlx01.hs-esslingen.de> <20100825211257.GA636@pema> <4C7588FB.4050001@zytor.com> <20100825225036.GV4762@const.famille.thibault.fr>
In-Reply-To: <20100825225036.GV4762@const.famille.thibault.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 03:50 PM, Samuel Thibault wrote:
> H. Peter Anvin, le Wed 25 Aug 2010 14:19:55 -0700, a écrit :
>> At that point I'd almost prefer doing something like a BIOS signature
>> check if we can't do anything better.
> 
> Well, there will be several versions of the BIOS signature, which the
> constructor is not likely to provide.
> 

Then we'll gather them up, or something.

> Just to make sure there's no misunderstanding: it was never planned that
> this driver be loaded unless some manual intervention, like explicitly
> loadling the module or setting some parameter, so that if bad effects
> happen on the machine, the user can only get angry at himself for having
> loaded by hand a random module without reading the documentation that
> explicitly says (twice) it's only for a particular kind of hardware.
> 
> I however now realize that I don't find a way to force a driver to be
> compiled only as a module.  If there isn't, I guess we can just add
> a module parameter to enable/disable the driver, so that it won't be
> active by default even compiled-in?

There is, but that is hardly a reasonable solution.

What other forms of enumerable hardware is on this machine?  PCI?

	-hpa
