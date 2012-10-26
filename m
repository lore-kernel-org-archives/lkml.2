Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2JZEoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:44:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:34036 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2JZEoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:44:22 -0400
Message-ID: <508A1505.6010809@gmail.com>
Date: Thu, 25 Oct 2012 21:43:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Daniel Vetter <daniel@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed...
 GPU hung
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com> <5088CC9B.6010009@gmail.com> <CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com> <84c8a8$68qvdl@orsmga001.jf.intel.com>
In-Reply-To: <84c8a8$68qvdl@orsmga001.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 01:47 AM, Chris Wilson wrote:
> On Thu, 25 Oct 2012 10:16:08 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Thu, Oct 25, 2012 at 7:22 AM, Justin P. Mattock
>> <justinmattock@gmail.com> wrote:
>>>
>>> here is a link to the file..: intel_error_decode
>>> http://www.filefactory.com/file/22bypyjhs4mx
>>
>> I haven't figured out how to access this thing. Can you please file a
>> bug report on bugs.freedesktop.org and attach it there?

Oops.. I filed with the kernel. maybe can just add a cc's
https://bugzilla.kernel.org/show_bug.cgi?id=49571

>
> No worries, it is another ILK hang similar to the ones reported earlier
> - it just seems the ring stops advancing. Hopefully it is a missing w/a
> from http://cgit.freedesktop.org/~danvet/drm/log/?h=ilk-wa-pile
> -Chris
>

well if this means building libdrm etc.. then thats not a problem, more 
time consuming if anything. perhaps an *.rpm that I can test to see?


Justin P. Mattock
