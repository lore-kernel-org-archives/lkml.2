Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1GYSRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:17:20 -0400
Received: from webmail1.b-one.net ([195.47.247.29]:47034 "EHLO
	webmail1.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1GYSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:17:19 -0400
Message-ID: <1ef7327eb07f3de0a776e22f724f92fc.squirrel@webmail01.one.com>
In-Reply-To: <4E2D97EC.8040002@sannes.org>
References: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>
    <20110722160832.ee535e0c.akpm@linux-foundation.org>
    <d2c55b0ee77728006676dfbc07b801d8.squirrel@webmail01.one.com>
    <4E2D97EC.8040002@sannes.org>
Date: Mon, 25 Jul 2011 20:17:17 +0200
Subject: Re: Possible bug in inotify api
From: Morten Winkler =?iso-8859-1?Q?J=F8rgensen?= <morten@winkler.dk>
To: =?iso-8859-1?Q?Asbj=F8rn_Sannes?= <ace@sannes.org>
Cc: morten@winkler.dk, "Andrew Morton" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Eric Paris" <eparis@redhat.com>
Reply-To: morten@winkler.dk
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> So perhaps we fixed whatever-it-was in a later kernel.  2.6.23 is
>>> pretty old!
>
> Actually it failed for me on 2.6.39.2
>
> Directory D-7 deleted in /tmp.
> Removes /tmp/D-7 as wd 8. Has 4994 watches
> Caught: No no no...

Ah. My colleague also saw this on an installation of the latest stable 
OpenSuSE, featuring a 2.6.37.6 kernel.

I've never attended this mailinglist before. Is there anything I should to
to assist the investigation? Or just be patient?

Morten

