Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0HDHjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:39:31 -0400
Received: from mx02.infracom.it ([62.196.48.11]:4516 "EHLO mx02.infracom.it"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932595Ab0HDHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:39:30 -0400
Message-ID: <4C59192F.3010304@infracom.it>
Date: Wed, 4 Aug 2010 09:39:27 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100710 Thunderbird/3.1
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
References: <4C4C9E40.7070209@infracom.it> <20100804083732.3d8dae69@tux.DEF.witbe.net>
In-Reply-To: <20100804083732.3d8dae69@tux.DEF.witbe.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 04/08/2010 08:37, Paul Rolland wrote:
> Hello Roberto,
>
> On Sun, 25 Jul 2010 22:27:44 +0200
> Roberto Oppedisano<roberto.oppedisano@infracom.it>  wrote:
>
>> My HP6730B (x86_64 kernel, uptodate lubuntu Lucid installed) fails to
>> suspend on recent git kernels, the screen goes black (backlight on) and
>> stays there forever.
> Have you checked the thread started by Thomas Meyer :
> 2.6.35-rc6+: i915: Bisected regression
>
> He describes something similar to your problem (and I was having the same),
> and the solution he indicates worked for him, for me, and a third person so
> far.
>
> Regards,
> Paul

Hello Roland,
     I did reply on the same thread confirming that that's the same 
issue I was having and that the proposed workaround did work for me.
After some days of testing I'm observing sporadic lockup on resume (not 
in suspend as in my original report), but I think this is another issue.

R
