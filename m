Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2BNCCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:02:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33441 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751191Ab2BNCCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:02:44 -0500
Message-ID: <1329184963.8143.2.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
From: Joe Perches <joe@perches.com>
To: Gustavo Padovan <padovan@profusion.mobi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 13 Feb 2012 18:02:43 -0800
In-Reply-To: <20120213215603.GA27753@joana>
References: <cover.1329102581.git.joe@perches.com>
	 <44b8744770a55924c68f8ad0ca274816d2d6148f.1329102581.git.joe@perches.com>
	 <1329114913.28848.50.camel@aeonflux> <20120213215603.GA27753@joana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 19:56 -0200, Gustavo Padovan wrote:
> it is not really a good idea to change BT_INFO to
> bt_info and BT_ERR to bt_err. I understand that capital letters are not the
> standard here but such a change is painful for all Bluetooth developers and I
> don't wanna give more trouble to them.

Hello Gustavo.

Standardization of use and style is a good thing.

What kind of trouble is a case conversion?
Out of tree modules?

> I'm ok if we only change bluetooth.h here.

I sent the patch I think appropriate.
If you want to strip out only the parts you
want, be my guest.

cheers, Joe

