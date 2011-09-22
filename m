Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1IVByU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:54:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:35397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1IVByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:54:18 -0400
Message-ID: <4E7A9544.9040006@infradead.org>
Date: Wed, 21 Sep 2011 22:54:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Arnaud Lacombe <lacombar@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: no tree for Sept 6
References: <20110906164049.4dd3961cb82800b8d7cc8741@canb.auug.org.au> <CACqU3MXcZ72eYNd=duPYdR_gOe-ejnHoLSMqK_ZU3y=MR2-0+A@mail.gmail.com> <CA+5PVA7CETUa0i3U20ifz5YjXAywTGD2NEQt1GcJz1OwY_DtEg@mail.gmail.com> <CACqU3MXQw4+QyBmCPcO8ZmYu0T6N+DStXBoa=JUv+ej6cWMTnw@mail.gmail.com> <CA+5PVA7Oj9BNTA93m8-rj4a7Ze_N7m3mG0-+GLG1zUSG+ekqJQ@mail.gmail.com> <CACqU3MW3w10LsZvyY4RNQ1-0TgrW39PaGeVnj78bk+p6c=1uFQ@mail.gmail.com> <4E677AF5.7050903@infradead.org> <20110911141958.8e404c8b943af1c73886cee5@canb.auug.org.au>
In-Reply-To: <20110911141958.8e404c8b943af1c73886cee5@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-09-2011 01:19, Stephen Rothwell escreveu:
> Hi Mauro,
> 
> On Wed, 07 Sep 2011 11:08:53 -0300 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>>
>> It seems that we need a backup plan. In my case, I could put the tree
>> for -next at infradead or at linuxtv, but that means to re-configure
>> everything at Stephen's side.
> 
> That is not a big issue at all.  If you wish to move your tree, just let
> me know (preferably in a public manner to raise my confidence in its
> provenance - I am a bit more paranoid, now :-)).

Hi Stephen,

Please replace my media tree (v4l-dvb) by this one:
	git://linuxtv.org/mchehab/media-next.git

I'll set soon a new tree for my edac patches as well.

Thank you!
Mauro

