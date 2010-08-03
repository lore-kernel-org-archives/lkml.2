Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0HCLlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:41:07 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:59930 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0HCLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:41:05 -0400
Date: Tue, 3 Aug 2010 13:40:59 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PC Beeps not working with HDA Intel module
Message-ID: <20100803114058.GA3074@pema>
References: <AANLkTild_NZP5B33ITuaS67bvuREiukbQCtcguKEO4XG@mail.gmail.com>
 <20100802181449.GA3071@pema>
 <AANLkTikU6_Cuaqk2xaPWCjkToMgd1yO8Y_qZ9Kcbk9c-@mail.gmail.com>
 <20100803081743.GA6566@pema>
 <AANLkTimn9n22zuDDd3YaAH--2OK=8j2UDTsxtsL5FqJo@mail.gmail.com>
 <AANLkTinC9cKet9-OSo1teWnJ_3HzvqYTsUPKPn_95nhm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinC9cKet9-OSo1teWnJ_3HzvqYTsUPKPn_95nhm@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Daniel & all,

> Ok, this patch works for me; I've modified it with the ground-truth we
> have (thus there are likely other codecs to fix up later). Shérab, can
> you test from your end?

Yeah it works perfectly, thanks !

One other question: the PC Beep controller in Alsa can take only four
values: 0%, 33%, 66% and 100%. What I find strange is that even when
it's at 0%, there is a beep, whose volume seems a bit strong to me. It
becomes stronger and stronger with the other values, which is normal,
but 0% seems to be non-equivalent to muting the control, I'm wondering
whether this is normal.
I'm also a bit disapointed that this control can take only those values,
for I'd appreciate to have an even softer beep, between the current 0%
and nothing at all.
Any insight would be very appreciated.

Best wishes,
Shérab, so happy to have recovered his beloved console bell.
