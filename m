Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2LXPmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 10:42:17 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55530 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2LXPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 10:42:15 -0500
MIME-Version: 1.0
In-Reply-To: <201212242238.23255.lindner_marek@yahoo.de>
References: <1353355695-23252-1-git-send-email-sasha.levin@oracle.com>
	<CANiGF9-_roU2oD5uTRvjvaS5=bv-VoRBdULZN3PtgFzs5z1=CQ@mail.gmail.com>
	<201212242238.23255.lindner_marek@yahoo.de>
Date: Mon, 24 Dec 2012 16:42:15 +0100
Message-ID: <CANiGF9_engsHHNUDnJi6+iczCdu7sBV+UuJ+Xv33pGuJxPeuAg@mail.gmail.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH] net, batman: don't crash on zero length
 strings in routing_algo
From: Pau Koning <paukoning@gmail.com>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
        Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 3:38 PM, Marek Lindner <lindner_marek@yahoo.de> wrote:
> On Monday, December 24, 2012 22:18:52 Pau Koning wrote:
>> On Mon, Nov 19, 2012 at 9:08 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> > The code that works with routing_algo assumes that the string passed is
>> > non
>>
>> > empty, this assumption is wrong:
>> Why isn't this patch part of Linux 3.7? It seems to be a bugfix and it
>> was sent early enough?
>
> The patch received a reply mere 2 hours after it was sent. Again, please read
> all mails before making noise.

Ok, leaving this problem unsolved is the correct way to handle it?
Nobody is allowed to say anything?
