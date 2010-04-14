Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0DNLyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 07:54:52 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:49264 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab0DNLyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:54:51 -0400
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4BC5AD08.8040606@tremplin-utc.net>
Date: Wed, 14 Apr 2010 13:54:48 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, Frank Griffin <ftg@roadrunner.com>
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
References: <4BC4E812.6050602@tremplin-utc.net> <s5h633u5zx1.wl%tiwai@suse.de> <4BC5A566.8060106@tremplin-utc.net>
In-Reply-To: <4BC5A566.8060106@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/10 13:22, Éric Piel wrote:
:
> I don't fully grasp the meaning of bdl_pos_adj, so I don't know if it's
> a bug to not play correctly when forcing it to 0. Is it?
> 
> I'll ask to another reporter who had the same problem if bdl_pos_adj is
> also set to 0...
Frank (cc'd here) has the same problem of music going too fast (on a
2.6.33 kernel with the "culprit" commit applied). On his system  "cat
/sys/module/snd_hda_intel/parameters/bdl_pos_adj" gives:
32,32,-1,-1,-1,-1,-1,-1

He also mentioned that on another system also using snd_hda_intel, with
the same bdl_pos_adj, it works fine.

Eric
