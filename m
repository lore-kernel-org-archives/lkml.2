Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0HCJCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:02:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab0HCJCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qZZUNI9Li3nBPAZm9dPfzjA02kW9qo0EezaskWZupQdqPqWaNdf44z1e4p0eKa9A83
         rGCCGPSgiXbBkqPop9cvRwiqVUJduNwLOPUWVZlHY20TYb9hLfb1SLWn6u91wY8utdPi
         fM1cOa+CT47PXclVUJeyCAT4Q05X2Lwgbwo58=
MIME-Version: 1.0
In-Reply-To: <20100803081743.GA6566@pema>
References: <AANLkTild_NZP5B33ITuaS67bvuREiukbQCtcguKEO4XG@mail.gmail.com>
	<20100802181449.GA3071@pema>
	<AANLkTikU6_Cuaqk2xaPWCjkToMgd1yO8Y_qZ9Kcbk9c-@mail.gmail.com>
	<20100803081743.GA6566@pema>
Date: Tue, 3 Aug 2010 10:02:33 +0100
Message-ID: <AANLkTimn9n22zuDDd3YaAH--2OK=8j2UDTsxtsL5FqJo@mail.gmail.com>
Subject: Re: PC Beeps not working with HDA Intel module
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: =?ISO-8859-1?B?U2jpcmFi?= <Sebastien.Hinderer@ens-lyon.org>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 August 2010 09:17, Shérab <Sebastien.Hinderer@ens-lyon.org> wrote:
> Dear Daniel and Takashi,
>
> First of all many thanks to both of you for your so prompt and so
> efficient reply ! Quite impressive.
>
> Daniel J Blueman (2010/08/02 22:41 +0100):
>> Testing with value 27 (ie 48000/4*27~=440), we hear the expected tone:
>> $ sudo ./hda-verb /dev/snd/hwC0D0 0x1c SET_BEEP_CONTROL 27
>> (of course, your beep widget may not be 0x1c)
>
> I don't know and don't even know what beep widget means, I'm sorry.
> If you can explain and also tell me where to find this hda-verb program
> you are using, I am willing to test if that's your wish.

hda-verb is at:
http://ftp1.kernel.org/pub/linux/kernel/people/tiwai/misc/hda-verb/hda-verb-0.3.tar.bz2

>From your alsa-info.sh, your beep widget (ie device) is at 0x26.

>> The problem is the assumption in patch_sigmatel.c:stac92xx_parse_auto_config():
>
> [...]
>
> So is there anything more I can/should do now ?

Nothing further, as we know the source of the issue.

Thanks,
  Daniel
-- 
Daniel J Blueman
