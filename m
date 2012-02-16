Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2BPQn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:43:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60639 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751859Ab2BPQny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:43:54 -0500
Message-ID: <1329410631.10890.3.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
From: Joe Perches <joe@perches.com>
To: Gustavo Padovan <padovan@profusion.mobi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Thu, 16 Feb 2012 08:43:51 -0800
In-Reply-To: <1329184963.8143.2.camel@joe2Laptop>
References: <cover.1329102581.git.joe@perches.com>
	 <44b8744770a55924c68f8ad0ca274816d2d6148f.1329102581.git.joe@perches.com>
	 <1329114913.28848.50.camel@aeonflux> <20120213215603.GA27753@joana>
	 <1329184963.8143.2.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 18:02 -0800, Joe Perches wrote:
> On Mon, 2012-02-13 at 19:56 -0200, Gustavo Padovan wrote:
> > it is not really a good idea to change BT_INFO to
> > bt_info and BT_ERR to bt_err. I understand that capital letters are not the
> > standard here but such a change is painful for all Bluetooth developers and I
> > don't wanna give more trouble to them.
[]
> Standardization of use and style is a good thing.
> What kind of trouble is a case conversion?
> Out of tree modules?

I'm truly curious as to why you think a
case conversion is painful and trouble.

Backward compatibility could be added via:

#define BT_ERR(fmt, ...)	bt_err(fmt "\n", ##__VA_ARGS__)
#define BT_INFO(fmt, ...)	bt_info(fmt "\n", ##__VA_ARGS__)


