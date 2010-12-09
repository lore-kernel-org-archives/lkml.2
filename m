Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0LIBvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:51:52 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36249 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab0LIBvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:51:50 -0500
Message-ID: <4D00361D.4000603@euromail.se>
Date: Thu, 09 Dec 2010 02:51:25 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
CC: Ping Cheng <pinglinux@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com> <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com> <20101208235805.GE15294@core.coreip.homeip.net> <AANLkTink9aX=dV-+n5=2BpPF34kSZGSQQ6x2tUNJ8eSM@mail.gmail.com> <AANLkTi=rjbzX9zzx-xvvhu7osKU8eUiPxi2=z=9H6YwJ@mail.gmail.com>
In-Reply-To: <AANLkTi=rjbzX9zzx-xvvhu7osKU8eUiPxi2=z=9H6YwJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQVfM-0005qR-CY.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQVfM-0005qR-CY fd423153aa3da9a3d01f8966f303f12b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 02:38 AM, Mohamed Ikbel Boulabiar wrote:

> On Thu, Dec 9, 2010 at 1:06 AM, Ping Cheng <pinglinux@gmail.com> wrote:
>> No, we are not talking about non-rectangular shape here. Envelop is
>> always a rectangle. By rectangle above, I meant 2 touches.
>>
>> An envelop that includes number of touches offers us more information
>> than a rectangle does
> 
> Can we have more information that just a rect ? An ellipse for exemple.
> Can we get this information at least from synaptics touchpads?


Unfortunately not. Chris Bagwell and myself have been experimenting with quite a
few different approaches to extract touch information from the synaptics pads.
The present approach, to extract the bounding rectangle, is the best we can do,
I am afraid - at least with the information unveiled in Takashi's original
patch. In particular, rotation information is not reliably extractable.

Henrik
