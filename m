Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2DIUH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:07:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59660 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2DIUH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1204090228060.24006@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204090201160.24006@pobox.suse.cz> <CAMOZ1BtxNhHxfbYfY+as7jpWHLO2P1QwCW_QpZbmQM+0xf1T=w@mail.gmail.com>
 <alpine.LNX.2.00.1204090228060.24006@pobox.suse.cz>
From: Michael Witten <mfwitten@gmail.com>
Date: Mon, 9 Apr 2012 20:07:27 +0000
Message-ID: <CAMOZ1BtS_3qxG1ZY5enQRMxKG9rvDbNxvy--D3yQOnPPwsBJhA@mail.gmail.com>
Subject: Re: [PATCH][Trivial] Delete trailing whitespace from sound/soc/codecs/wm8994.c
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@chaosbits.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 00:29, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 9 Apr 2012, Michael Witten wrote:
>
>> >> While reading through sound/soc/codecs/wm8994.c I noticed a fair
>> >> amount of trailing whitespace. This patch gets rid of it.
>> >>
>> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> >
>> > Jesper,
>> >
>> > is it really worth it? The code should have been fixed before merging,
>> > yes, but once it's there, such fixups tend to only make people angry
>> > (because they have to do unnecessary extra steps during git blame).
>>
>> If I may interject, I assume you mean that nobody wants to see the
>> fact that somebody simply changed whitespace. However, the text of
>> `git help blame' suggests that the `-w' flag obviates the issue:
>>
>>   Ignore whitespace when comparing the parent's
>>   version and the child’s to find where the lines
>>   came from.
>>
>> Of course, I've never used it, so I may be mistaken in my
>> interpretation.
>
> That indeed does what it should do, but as it's not git default, then
> quitting git blame and reruning it with '-w' seems to be equally annoying
> to quitting git blame and reruning it with 'particular_commit~1"

It seems to me that something must be terribly wrong with our tools
and workflows whenever an improvement (for which the main work has
already been done, no less) is turned down.

Perhaps that `-w' option should become the default.
