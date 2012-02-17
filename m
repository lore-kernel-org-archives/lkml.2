Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab2BQSMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:12:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57341 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751831Ab2BQSMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:12:23 -0500
Message-ID: <1329502342.584.4.camel@joe2Laptop>
Subject: Re: [PATCH V2 2/3] bluetooth: Convert BT_ERR/BT_INFO to
 bt_err/bt_info
From: Joe Perches <joe@perches.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 17 Feb 2012 10:12:22 -0800
In-Reply-To: <20120217094110.GB12814@x220>
References: <cover.1329461202.git.joe@perches.com>
	 <6737e9dc6d2528f9c94c122709a40e4c23c9477a.1329461203.git.joe@perches.com>
	 <1329468018.28848.133.camel@aeonflux> <20120217094110.GB12814@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 11:41 +0200, Johan Hedberg wrote:
> Patches 2/3 and 3/3 have never actually made it to the linux-bluetooth
> list (I've never seen them and they're not visible in the archives
> either). Doing the split like Marcel proposes would probably solve the
> issue since I'm guessing the large message size is to blame.

Hi Johan.

I'm not subscribed to linux-bluetooth.

linux-bluetooth is a vger list so I would expect
the maximum message size to be no different than
lkml though.  These messages did get through to
netdev and lkml.

http://patchwork.ozlabs.org/patch/141748/
http://patchwork.ozlabs.org/patch/141749/

You're not listed as a bluetooth maintainer.
Should you be?

Do you want the original patch set sent directly
to you?

