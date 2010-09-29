Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0I2Id3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:33:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64448 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0I2Id1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PVZkO+KFXNWuheI4NxjTUHw6zOb+vMOiw8cbR701FImfDcR2sdF2CSD0ajd5tJWYbq
         0mkqeTfttpsVfWtsjLs1vqhZaksLYIU02fLHkwXxivokJUm2m4GcLtyhSR5gawMs4an5
         pg57TmLwGEN9dyaeWsBuFLWOFh5BY4y52QxCo=
Message-ID: <4CA2F9D2.7020006@gmail.com>
Date: Wed, 29 Sep 2010 10:33:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch
Subject: Re: i915: glxgears causes GPU hang [was: mmotm 2010-09-22-16-11 uploaded]
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org> <4CA065B8.1060206@gmail.com> <89k83a$9pqvca@azsmga001.ch.intel.com>
In-Reply-To: <89k83a$9pqvca@azsmga001.ch.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 11:51 AM, Chris Wilson wrote:
> On Mon, 27 Sep 2010 11:36:56 +0200, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 09/23/2010 01:12 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
>>
>> Hi, when I run glxgears in this kernel, X crashes. It happens also with
>> older releases and I don't know what is the first defunct.
>>
>> In the log there is:
>> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
>> [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
>> (awaiting 2 at 0)
> 
> Hmm, that's a serious error as it appears the chip wasn't initialised
> correctly and failed to start. G33, this is likely to be
> https://bugzilla.kernel.org/show_bug.cgi?id=16891

Well, it's gone with mmotm 2010-09-28-16-13...

thanks,
-- 
js
