Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab1GWFrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 01:47:08 -0400
Received: from webmail1.b-one.net ([195.47.247.29]:27674 "EHLO
	webmail1.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1GWFq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 01:46:59 -0400
Message-ID: <d2c55b0ee77728006676dfbc07b801d8.squirrel@webmail01.one.com>
In-Reply-To: <20110722160832.ee535e0c.akpm@linux-foundation.org>
References: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>
    <20110722160832.ee535e0c.akpm@linux-foundation.org>
Date: Sat, 23 Jul 2011 07:46:58 +0200
Subject: Re: Possible bug in inotify api
From: Morten Winkler =?iso-8859-1?Q?J=F8rgensen?= <morten@winkler.dk>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: morten@winkler.dk, linux-kernel@vger.kernel.org,
        "Eric Paris" <eparis@redhat.com>
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

Hi Andrew.

>> Attached: C++ program used to reproduce the behavior.
>
> I ran it a couple of times on my 2.6.32-based 2-CPU desktop here and it
> ran to completion without any complaints.
>
> So perhaps we fixed whatever-it-was in a later kernel.  2.6.23 is
> pretty old!

I see. Thank you for trying out. Once our situation allows for a kernel
update I'll do so. In the meanwhile, I'll have to think of something else.
Also, I'll try on other machines with newer kernels.

Again, thank you for your effort

Best,
   Morten

