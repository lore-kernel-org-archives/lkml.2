Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2J0TL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:11:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43025 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab2J0TL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:11:57 -0400
Message-ID: <508C31EB.2030202@gmail.com>
Date: Sat, 27 Oct 2012 12:11:39 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed...
 GPU hung
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com> <5088CC9B.6010009@gmail.com> <CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com> <84c8a8$68qvdl@orsmga001.jf.intel.com> <508A1505.6010809@gmail.com> <CAKMK7uHm8OXPGmYa3zgn64mmufgGMmqiAE=+5ugBBKQ+i6PTag@mail.gmail.com> <508AF938.9090004@gmail.com> <CAKMK7uEa2fBVvxpwzomgWiZMZOU2O+v=EdL=w_HeccTsTag0-A@mail.gmail.com>
In-Reply-To: <CAKMK7uEa2fBVvxpwzomgWiZMZOU2O+v=EdL=w_HeccTsTag0-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 06:56 AM, Daniel Vetter wrote:
> On Fri, Oct 26, 2012 at 10:57 PM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>>
>> :~/drm> git clone git://people.freedesktop.org/~danvet/drm
>> Cloning into 'drm'...
>> remote: Counting objects: 2728390, done.
>> remote: Compressing objects: 100% (418606/418606), done.
>> remote: Total 2728390 (delta 2293727), reused 2717443 (delta 2282880)
>> Receiving objects: 100% (2728390/2728390), 637.95 MiB | 599 KiB/s, done.
>> Resolving deltas: 100% (2293727/2293727), done.
>> warning: remote HEAD refers to nonexistent ref, unable to checkout.
>>
>>
>> so now I have to go on a witch hunt for 600MB's in my system.
>
> $ git checkout origin/ilk-wa-pile

cool thanks..(not so good at git over here).
>
> ... and you have the right branch checked out. No need for pitchforks
> and witch hunts ;-)
> -Daniel
>


alright.. putting the pitchfork away for now.

Justin P. Mattock

