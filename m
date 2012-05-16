Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2EPQqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:46:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44681 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab2EPQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <1337184643.4818.8.camel@joe2Laptop>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <1337184643.4818.8.camel@joe2Laptop>
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Wed, 16 May 2012 18:46:20 +0200
Message-ID: <CAFU-uVv3Nx7hK73RvXtRUD43EoCyY_ER+oe5RScPc32VuuDpPA@mail.gmail.com>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
To: Joe Perches <joe@perches.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Greg KH <greg@kroah.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/16 Joe Perches <joe@perches.com>:
> On Wed, 2012-05-16 at 16:25 +0200, Philipp Riemer wrote:
>> This leads to the fact that many people have
>> typos in there names or use ".local" or ".(none)" email addresses.
>> Hence, Git supports .mailmap files to overcome this and correct known
>> mistakes.
> []
>> But I would say that
>> this file is as good as done.
>
> Why add these entries at all again?
Due to the research for my thesis, I tried to find out how many
developers are contributing to the Linux Kernel. First I thought that
this would be easy since there was already a mailmap file that
contained information about ambiguous email addresses. But I
discovered pretty fast that there were more names with typos etc. so
that I started to add those to the file as well.

> For instance, my name is listed once in your patch.
> and I don't see a reason it should be entered at all.
Your name appears in the list because I did a search and you are
listed with three "different" entries:
* Joe Perches <joe@perches.com>
* joe@perches.com <joe@perches.com>
* Joe Perches <joe@perches.ccom>

Actually, I just realized that I even forgot to add the entry for the
".ccom" and will add it before re-submitting.

> Many developers share a common name and some of
> these entries may be not be correct.
I will re-check every entry again (based on the type of contribution/
part of interest/ company) before re-submitting.

> Some developers purposefully use multiple email
> addresses to allow direct responses to be categorized
> on receipt.
I must agree that I did not consider this point. I will have a look
and might change some entries accordingly.

Thank you very much for your feedback.
