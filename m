Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab2BMVyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:54:40 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33547 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BMVyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:54:37 -0500
Date: Mon, 13 Feb 2012 19:56:03 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
Message-ID: <20120213215603.GA27753@joana>
Mail-Followup-To: Marcel Holtmann <marcel@holtmann.org>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <cover.1329102581.git.joe@perches.com>
 <44b8744770a55924c68f8ad0ca274816d2d6148f.1329102581.git.joe@perches.com>
 <1329114913.28848.50.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329114913.28848.50.camel@aeonflux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

* Marcel Holtmann <marcel@holtmann.org> [2012-02-13 07:35:13 +0100]:

> Hi Joe,
> 
> > Make functions for bt_info and bt_err.
> > Remove now unused function bt_printk.
> > Convert uses of BT_INFO and BT_ERR to bt_info and bt_err.
> 
> That is all fine, but why not just change BT_INFO to point to bt_info
> and BT_ERR to bt_err first instead of having this huge patch mixed in
> with the changes. The size measurement should be no different.

I'm with Marcel here, it is not really a good idea to change BT_INFO to
bt_info and BT_ERR to bt_err. I understand that capital letters are not the
standard here but such a change is painful for all Bluetooth developers and I
don't wanna give more trouble to them. I'm ok if we only change bluetooth.h
here.

	Gustavo
