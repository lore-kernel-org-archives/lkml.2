Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0KRM1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:27:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38630 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0KRM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:27:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Kv0ph3XDcznd2WotCXbh29Z/YGKuLFRf+zQS/uLCjtL+8ZLKgV6z/4kzC60XBiQYl1
         q9koVG/0Xga0c5y3m1FuQWByoEf9kFLwzM4tn8Jff52lJ0BQxTpodKEsZMw03s/U551c
         Kag2FHV8Mvx1cFPg0lHjYy8xBKMId5Q9qZDjM=
MIME-Version: 1.0
In-Reply-To: <20101118095300.3ea74268@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
	<AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
	<20101117162922.0f874a8e@kryten>
	<20101118095300.3ea74268@lxorguk.ukuu.org.uk>
Date: Thu, 18 Nov 2010 14:27:02 +0200
Message-ID: <AANLkTi=Ntr-_yzoOqddpepyJU70JH-yqD4tYofuq2KyQ@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anton Blanchard <anton@au1.ibm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:53 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Only in this case I can't help feeling that the virtualisation work
> already bypassed C/R,

This discussion should have happened like 10 years ago. :-\

> solved the problem space that a lot of people care about and then moved on.
