Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab0COPAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:00:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065Ab0COPAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:00:38 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: [PATCH 0/3] gigaset fixes for 2.6.34-rc1
Date: Mon, 15 Mar 2010 16:00:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.42-0.1-default; KDE/4.4.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, Hansjoerg Lipp <hjlipp@web.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1268580322.git.tilman@imap.cc>
In-Reply-To: <cover.1268580322.git.tilman@imap.cc>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003151600.29048.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX1+aSx9RjR2VcYq7mOmx2HH3jVb5oI5puYQvFof
 88Ig0IEnsTzzCx3nNNbG/qn7LaaC3UXnfCQkr1oejXF9knfUdb
 4HfYliDnbasOYARMji5LMy+bc/MhHSY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 14. März 2010 23:58:05 Tilman Schmidt wrote:
> Karsten, David,
> 
> following are three bugfix patches to the Gigaset driver which should
> still go into 2.6.34 if possible, and also into the 2.6.33 stable branch.

Ack for all

> 
> Thanks,
> Tilman
> 
> Tilman Schmidt (3):
>   gigaset: avoid registering CAPI driver more than once
>   gigaset: correct clearing of at_state strings on RING
>   gigaset: prune use of tty_buffer_request_room
> 
>  drivers/isdn/gigaset/capi.c      |   44
>  +++++++++++++++++++++---------------- drivers/isdn/gigaset/common.c    |  
>   6 +++-
>  drivers/isdn/gigaset/ev-layer.c  |   12 +++-------
>  drivers/isdn/gigaset/gigaset.h   |    6 +++-
>  drivers/isdn/gigaset/i4l.c       |   28 +++++++++++++++++-------
>  drivers/isdn/gigaset/interface.c |    1 -
>  6 files changed, 57 insertions(+), 40 deletions(-)
> 
