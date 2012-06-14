Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2FNOFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:05:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51081 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2FNOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:05:41 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com>
References: <4FD9E69A.4090708@cwi.nl>
	<CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com>
Date: Thu, 14 Jun 2012 16:05:40 +0200
Message-ID: <CAKMK7uGokt5cW0R+LKXRmE_kecqmnv4Zgy-WiSZA-GPP8htE-A@mail.gmail.com>
Subject: Re: [3.4 regression] [bisected] DisplayPort fails to come on
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        intergalactic.anonymous@gmail.com, len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>,
        "Wilson, Chris" <chris.wilson@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 4:00 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Thu, Jun 14, 2012 at 2:26 PM, Wouter M. Koolen
> <W.M.Koolen-Wijkstra@cwi.nl> wrote:
> cc'ing Daniel.
>
>> Hi Igor and Len,
>>
>> When I cold boot 3.4 on my laptop the second monitor attached to the
>> displayport stays blank. It works fine with 3.3.8 and earlier.
>>
>> I get two error messages in dmesg:
>>
>> kernel: video: probe of LNXVIDEO:00 failed with error -5
>>
>> kernel: [drm:intel_dp_complete_link_train] *ERROR* failed to train DP,
>> aborting
>>
>> When I warm boot 3.4 after running kernel 3.3.8 first, only the first
>> message appears and the display works fine.

Ok, the second message is actually the one explaining the black
screen. Can you please boot with drm.debug=0xe added to your kernel
cmdline and attach the full dmesg, so we know a bit what your display
hw looks like?

Also, please redo the bisect if possible (with coldboots) and hunt for
the black screen/the "failed to train DP" message.

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
