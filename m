Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0HCIRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:17:49 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:51864 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0HCIRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:17:46 -0400
Date: Tue, 3 Aug 2010 10:17:43 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PC Beeps not working with HDA Intel module
Message-ID: <20100803081743.GA6566@pema>
References: <AANLkTild_NZP5B33ITuaS67bvuREiukbQCtcguKEO4XG@mail.gmail.com>
 <20100802181449.GA3071@pema>
 <AANLkTikU6_Cuaqk2xaPWCjkToMgd1yO8Y_qZ9Kcbk9c-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikU6_Cuaqk2xaPWCjkToMgd1yO8Y_qZ9Kcbk9c-@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Daniel and Takashi,

First of all many thanks to both of you for your so prompt and so
efficient reply ! Quite impressive.

Daniel J Blueman (2010/08/02 22:41 +0100):
> Testing with value 27 (ie 48000/4*27~=440), we hear the expected tone:
> $ sudo ./hda-verb /dev/snd/hwC0D0 0x1c SET_BEEP_CONTROL 27
> (of course, your beep widget may not be 0x1c)

I don't know and don't even know what beep widget means, I'm sorry.
If you can explain and also tell me where to find this hda-verb program
you are using, I am willing to test if that's your wish.

> The problem is the assumption in patch_sigmatel.c:stac92xx_parse_auto_config():

[...]

So is there anything more I can/should do now ?

Thanks !
Shérab.
