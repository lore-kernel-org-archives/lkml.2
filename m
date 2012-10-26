Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508Ab2JZRgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:36:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49411 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2JZRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:36:07 -0400
Message-ID: <508AC9F5.2000403@gmail.com>
Date: Fri, 26 Oct 2012 10:35:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed...
 GPU hung
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com> <5088CC9B.6010009@gmail.com> <CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com> <84c8a8$68qvdl@orsmga001.jf.intel.com> <508A1505.6010809@gmail.com> <CAKMK7uHm8OXPGmYa3zgn64mmufgGMmqiAE=+5ugBBKQ+i6PTag@mail.gmail.com>
In-Reply-To: <CAKMK7uHm8OXPGmYa3zgn64mmufgGMmqiAE=+5ugBBKQ+i6PTag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:05 AM, Daniel Vetter wrote:
> On Fri, Oct 26, 2012 at 6:43 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>>>
>>> No worries, it is another ILK hang similar to the ones reported earlier
>>> - it just seems the ring stops advancing. Hopefully it is a missing w/a
>>> from http://cgit.freedesktop.org/~danvet/drm/log/?h=ilk-wa-pile
>>> -Chris
>>>
>>
>> well if this means building libdrm etc.. then thats not a problem, more time
>> consuming if anything. perhaps an *.rpm that I can test to see?
>
> It's not libdrm, the above is just a kernel git tree with a bunch of
> ironlake workarounds.
> -Daniel
>


hmm.. then in that case maybe I should pull and run that kernel to see 
if the crash occurs, before bisecting(if anything).
will do once I get time to download.

Justin P. Mattock
