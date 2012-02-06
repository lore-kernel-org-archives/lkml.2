Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2BFK6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:58:34 -0500
Received: from mail2.rz.htw-berlin.de ([141.45.10.102]:56546 "EHLO
	mail2.rz.htw-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2BFK6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:58:33 -0500
Message-ID: <4F2FB236.5040608@rockbox.org>
Date: Mon, 06 Feb 2012 11:57:58 +0100
From: Thomas Martitz <kugel@rockbox.org>
Organization: Rockbox
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: r600 hdmi sound issue
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-HTW-SPAMINFO: this message was scanned by eXpurgate (http://www.eleven.de)
X-HTW-DELIVERED-TO: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

this is in reply to[1].

2011/11/9 Rafa≈ Mi≈ecki <zajec5@xxxxxxxxx>:
 > 2011/11/9 Greg Dietsche <greg@xxxxxxxxx>:
 >> Hi,
 >> I have a ASUS M4A89GTD motherboard and when I play back music in 
Rhythmbox,
 >> there is no sound (hdmi connection). Also, the playback speed is in 
a sort
 >> of fast forward (for example, after a few seconds of real time, 
rhythmbox
 >> shows something like 30 seconds into the song). This seems to be a 
kernel
 >> regression. I know that it started with 3.0, is present in 3.1, and 
is not
 >> working in 3.2-rc1, so it is still a problem.
 >>
 >> I bisected and found my self here: 
fe6f0bd03d697835e76dd18d232ba476c65b8282.
 >> However due to some graphical issues, I'm not actually able to test that
 >> commit. I tried reverting that commit, but the problem wasn't fixed.
 >>
 >> I'd like to see this problem fixed and can compile and test patches as
 >> necessary. Please let me know if you need more information - I'm 
happy to
 >> provide it :)
 >
 > fe6f0bd03d697835e76dd18d232ba476c65b8282 is not likely. I suspect you
 > just experience results of so-called-fix:
 >
 > 805c22168da76a65c978017d0fe0d59cd048e995
 >
 > drm/radeon/kms: disable hdmi audio by default
 >
 > I'm trying to get in contact with ppl affected by issues when enabling
 > audio. Hopefully we can fix audio support and enable it by default
 > again.
 >
 > For now, please load radeon module with "audio=1", or simply boot with
 > radeon.audio=1
 >


I am affected by this. Enabling hdmi audio makes hdmi video go wrong. 
With audio enabled I'm unable to get a picture onto any external 
display. With audio=0 at least video works fine. It's possible that 
805c221 is a result of the bug report I filed at [2].

I'm glad if I can be of any help to resolve the issue. FWIW, I'm 
familiar with compiling the kernel and applying patches.

Best regards.


[1]: https://lkml.org/lkml/2011/11/9/41
[2]: https://bugs.freedesktop.org/show_bug.cgi?id=38170
