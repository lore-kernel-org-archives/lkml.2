Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2EPQKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:10:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37240 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756259Ab2EPQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:10:44 -0400
Message-ID: <1337184643.4818.8.camel@joe2Laptop>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
From: Joe Perches <joe@perches.com>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Greg KH <greg@kroah.com>, Jonathan Corbet <corbet@lwn.net>
Date: Wed, 16 May 2012 09:10:43 -0700
In-Reply-To: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 16:25 +0200, Philipp Riemer wrote:
> This leads to the fact that many people have
> typos in there names or use ".local" or ".(none)" email addresses.
> Hence, Git supports .mailmap files to overcome this and correct known
> mistakes.
[]
> But I would say that
> this file is as good as done.

Why add these entries at all again?

For instance, my name is listed once in your patch.
and I don't see a reason it should be entered at all.

Many developers share a common name and some of
these entries may be not be correct.

Some developers purposefully use multiple email
addresses to allow direct responses to be categorized
on receipt.


