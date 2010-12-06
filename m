Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0LFUHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:07:36 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:34686 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0LFUHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:07:35 -0500
Date: Mon, 6 Dec 2010 18:07:51 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Joe Perches <joe@perches.com>
Cc: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bluetooth: Use printf extension %pMbt
Message-ID: <20101206200751.GF883@vigoh>
References: <cover.1291419007.git.joe@perches.com>
 <b966e9510dec12556a3d1313b026cb2c8281e4d6.1291419007.git.joe@perches.com>
 <20101206181507.GC883@vigoh>
 <1291661413.17494.219.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1291661413.17494.219.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

* Joe Perches <joe@perches.com> [2010-12-06 10:50:13 -0800]:

> On Mon, 2010-12-06 at 16:15 -0200, Gustavo F. Padovan wrote:
> > This patch doesn't apply to the bluetooth-next-2.6 tree.
> > Can you please rebase it against the bluetooth-next-2.6 tree?
> 
> No worries, it was done against next-20101202.
> 
> Do you care about using %pMR vs %pMbt as Michał suggested in
> https://lkml.org/lkml/2010/12/4/21 ?

I'm fine either way. It depends more if another subsystem will want to use
%pMR or not as you said.

-- 
Gustavo F. Padovan
http://profusion.mobi
