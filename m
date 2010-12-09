Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0LIBS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:18:58 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57892 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919Ab0LIBS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:18:57 -0500
Message-ID: <4D002E6A.7070709@euromail.se>
Date: Thu, 09 Dec 2010 02:18:34 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>	<4CFFC3C2.1080905@canonical.com>	<AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>	<20101208235805.GE15294@core.coreip.homeip.net> <AANLkTink9aX=dV-+n5=2BpPF34kSZGSQQ6x2tUNJ8eSM@mail.gmail.com>
In-Reply-To: <AANLkTink9aX=dV-+n5=2BpPF34kSZGSQQ6x2tUNJ8eSM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQV9Y-00071s-7P.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PQV9Y-00071s-7P 3fd1040eb5ea75a261eb3d55c13f9c86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Those are good questions. Specifying how many touches are in the

>>> envelop makes sense. It also covers rectangle as a special case of
>>> envelop.
>>
>> I have a feeling that trying to accomodate non-rectangular,
> 
> No, we are not talking about non-rectangular shape here. Envelop is
> always a rectangle. By rectangle above, I meant 2 touches.
> 
> An envelop that includes number of touches offers us more information
> than a rectangle does.


All you need to do to know how many points there are is to count them. :-)

Henrik
