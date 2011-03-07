Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1CGUwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:52:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:37774 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CGUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:52:36 -0500
Message-ID: <4D754591.1090602@windriver.com>
Date: Mon, 07 Mar 2011 15:52:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110127 Thunderbird/3.1.7
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
References: <4D71668F.9050201@windriver.com> <4D748070.1030502@localhost> <4D753970.4030607@localhost> <4D7542E9.4000008@localhost>
In-Reply-To: <4D7542E9.4000008@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2011 20:52:34.0648 (UTC) FILETIME=[95B7B580:01CBDD09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-07 03:41 PM, Fernando Lopez-Lezcano wrote:
> On 03/07/2011 12:00 PM, Fernando Lopez-Lezcano wrote:
>> On 03/06/2011 10:51 PM, Fernando Lopez-Lezcano wrote:
>>> On 03/04/2011 02:24 PM, Paul Gortmaker wrote:
>>>> As a value add to the 2.6.34 long term release, I'm happy to also
>>>> announce the availability of 2.6.34-RT.
>>>>
>>>> You can find it in the v2.6.34-rt branch at:
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
>>>
>>> Great! Many thanks... Actually, impressive work.
>>>
>>> I'm trying to integrate/build it into my Fedora based rt packages for
>>> Planet CCRMA. Warning: I'm doing this on top of the 2.6.34.8-68 fc13
>>> koji build, so rt is patched on top of the additional Fedora patches for
>>> that build (with a few trivial tweaks to patch cleanly). So I don't know
>>> if the following issues are due to that...
>>
>> Caveat above still applies...
> ...
>> - EeePC netbook, Fedora 13, Intel Mobile 945GME graphics: X does not start
>> - Lenovo laptop, fedora 14, Intel 9xx graphics (at home): X does not start
>> These last two share Intel graphics and the problem seems to be the
>> same, something to do with dri.
> 
> This is what I'm getting (dmesg|grep i915):
> 
> i915 0000:00:02.0 PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0 setting latency timer to 64
> i915 0000:00:02.0 PCI INT A disabled
> i915: probe of 0000:00:02.0 failed with error -5
> 
> Same kernel w/o rt...:
> 
> i915 0000:00:02.0 PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0 setting latency timer to 64
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> So, some problem with irq processing?
> Where should I go look?

Try v2.6.33-rt -- see if it is a new regression, or was a problem that
already existed and has just been carried forward.

P.

> -- Fernando
