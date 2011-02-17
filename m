Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1BQRDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:03:49 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:33515 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932250Ab1BQRDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:03:46 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: uuYqY4YVM1mctf3HPAIS7ooWQny70weqveGuLvKBiS1N51B
 7jhu6FUOw0TTdXPuu3lxjen_6dbmCFeoxlWDfMwa8KuA9ln3dhclV5FFeU3X
 g5ZkM8DPhXHGqI.yAa84W0XRI6.6zKXh.4.puRzWFuSdrEtBWSmoiKX8X3g3
 Iwk7miMMKDB2vT9PUYQsW1JZe67Q_sJy3YfIKTM03zu9LDmW9_AfHFHBNUg2
 Yu8fVRZZ_dE9_k7O_afWRF.U8Ixbwztpm5AVT8xn85dBtyOOmM.etc_s7pZ8
 qG7e90y.ENGWMdYB1c9h4eX9nJFPjYxcY3rnMMHxXtnSmvEg-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Feb 2011 11:03:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.com>
cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4D5CCEED.3010501@q-leap.com>
Message-ID: <alpine.DEB.2.00.1102171102520.11140@router.home>
References: <4D53FE43.8030106@q-leap.com> <alpine.DEB.2.00.1102141046170.26158@router.home> <4D5A2EDB.8060603@q-leap.com> <alpine.DEB.2.00.1102151040560.10511@router.home> <4D5BC16A.2090205@q-leap.com> <alpine.DEB.2.00.1102160956250.27814@router.home>
 <4D5BF56F.1000504@q-leap.com> <alpine.DEB.2.00.1102161010330.27814@router.home> <4D5CCEED.3010501@q-leap.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1102171102522.11140@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Peter Kruse wrote:

> Christoph Lameter wrote:
> > Oww. A large number of additional higher order allocations from iptables.
> > Order 6. But still only partial boot message. I need to see the memory
> > layout discovered by the kernel and for that I need the early boot messages.
>
> ok, I attach the early dmesg I hope this contains the information
> you need.

No it only contains what you sent before. I need the early boot
messages.


y
