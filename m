Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1FTAn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:43:59 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:34311 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1FTAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:43:57 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
In-Reply-To: <BANLkTi=6hKExj-LrOPBBhF4ym_YZNVG3Sg@mail.gmail.com>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl> <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl> <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com> <18273.1308192226@jrobl> <BANLkTimhL5BG9gHOG0Fr9U5fLkE0NJvpng@mail.gmail.com> <12737.1308237353@jrobl> <BANLkTi=6hKExj-LrOPBBhF4ym_YZNVG3Sg@mail.gmail.com>
Date: Mon, 20 Jun 2011 09:43:48 +0900
Message-ID: <6167.1308530628@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Suchanek:
> Is there any reason why a directory cannot be whiteout?

Just to reduce consuming inodes.


> It may possibly hide a XXXXXXXX file if it is later added to the lower layer.

No, because it is "doubly" whiteouted.


> Just as whiteout has totally different file-type from a file. It's
> specific to the union.

Ok, we are talking about different whiteouts.


J. R. Okajima
