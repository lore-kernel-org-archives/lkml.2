Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2LXOp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 09:45:29 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50377 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2LXOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 09:45:26 -0500
X-Greylist: delayed 1594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 09:45:26 EST
MIME-Version: 1.0
In-Reply-To: <1353355695-23252-1-git-send-email-sasha.levin@oracle.com>
References: <1353355695-23252-1-git-send-email-sasha.levin@oracle.com>
Date: Mon, 24 Dec 2012 15:18:52 +0100
Message-ID: <CANiGF9-_roU2oD5uTRvjvaS5=bv-VoRBdULZN3PtgFzs5z1=CQ@mail.gmail.com>
Subject: Re: [PATCH] net, batman: don't crash on zero length strings in routing_algo
From: Pau Koning <paukoning@gmail.com>
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
Cc: lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 9:08 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> The code that works with routing_algo assumes that the string passed is non
> empty, this assumption is wrong:

Why isn't this patch part of Linux 3.7? It seems to be a bugfix and it
was sent early enough?
