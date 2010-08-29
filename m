Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0H2Lco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 07:32:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60532 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0H2Lcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 07:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xQCn3ba6619WJ9w5pRZ8+mnNoc6IJ4oNJIE0xLHyTY/M3tmTuOTzOVRLCm+7AoQXmO
         4QXCE85K2HmOevYPLbWmO7p66cB42qqevyepErRsjFWie/K/+MjTzgcFiAAKKcPeeL4u
         L8ZxJxrbs5abOxJzSGJSVsldMBjdyrEsnlwZE=
MIME-Version: 1.0
In-Reply-To: <201008262027.24729.maciej.rutecki@gmail.com>
References: <alpine.DEB.2.00.1008221821370.4027@tiger>
	<201008262027.24729.maciej.rutecki@gmail.com>
Date: Sun, 29 Aug 2010 14:32:41 +0300
X-Google-Sender-Auth: zdesSwOGd1eQFntFouQfXKSNUoo
Message-ID: <AANLkTikMK7WJAfBHUXi_VMyJQBQT69ZfA7LwKfp5c-r8@mail.gmail.com>
Subject: Re: [PROBLEM] i915/drm: Insufficient FIFO for plane
From: Pekka Enberg <penberg@kernel.org>
To: maciej.rutecki@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>, sitsofe@yahoo.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 9:27 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> On niedziela, 22 sierpnia 2010 o 17:26:19 Pekka Enberg wrote:
>> Hi,
>>
>> I'm seeing tons of these error messages with current Linus' git:
>>
>> [   95.941618] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
>> plane, expect flickering: entries required = 36, available = 31.
>>
>> Contrary to the error message, I don't see any flickering. I've attached
>> my dmesg and config.
>>
> See:
> https://bugzilla.kernel.org/show_bug.cgi?id=17021

The "insufficient FIFO for plane" problem seems to have gone away with
latest Linus' git. I suppose commit
9559fcdbff4f93d29af04478bbc48294519424f5 ("drm/i915: fix vblank wait
test condition") fixed it although I don't see any mention of the
error in the changelog?

                         Pekka
