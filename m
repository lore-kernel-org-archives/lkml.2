Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2BPSDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:03:40 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:39157 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2BPSDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:03:38 -0500
Date: Thu, 16 Feb 2012 16:05:07 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
Message-ID: <20120216180507.GA5280@joana>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <cover.1329102581.git.joe@perches.com>
 <44b8744770a55924c68f8ad0ca274816d2d6148f.1329102581.git.joe@perches.com>
 <1329114913.28848.50.camel@aeonflux>
 <20120213215603.GA27753@joana>
 <1329184963.8143.2.camel@joe2Laptop>
 <1329410631.10890.3.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329410631.10890.3.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

* Joe Perches <joe@perches.com> [2012-02-16 08:43:51 -0800]:

> On Mon, 2012-02-13 at 18:02 -0800, Joe Perches wrote:
> > On Mon, 2012-02-13 at 19:56 -0200, Gustavo Padovan wrote:
> > > it is not really a good idea to change BT_INFO to
> > > bt_info and BT_ERR to bt_err. I understand that capital letters are not the
> > > standard here but such a change is painful for all Bluetooth developers and I
> > > don't wanna give more trouble to them.
> []
> > Standardization of use and style is a good thing.
> > What kind of trouble is a case conversion?
> > Out of tree modules?
> 
> I'm truly curious as to why you think a
> case conversion is painful and trouble.

Such a change will require rebase from all our developers and we already have
enough issues to solve, I don't wanna add one more here. Change what BT_*
stands for is ok, but there is no need to change the macros names. 

	Gustavo
