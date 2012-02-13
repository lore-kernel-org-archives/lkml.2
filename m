Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2BMH2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:28:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35115 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755023Ab2BMH2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:28:03 -0500
Message-ID: <1329118080.31068.4.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Sun, 12 Feb 2012 23:28:00 -0800
In-Reply-To: <1329117706.28848.55.camel@aeonflux>
References: <cover.1329102581.git.joe@perches.com>
	 <44b8744770a55924c68f8ad0ca274816d2d6148f.1329102581.git.joe@perches.com>
	 <1329114913.28848.50.camel@aeonflux> <1329115573.30878.1.camel@joe2Laptop>
	 <1329117706.28848.55.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 08:21 +0100, Marcel Holtmann wrote:
> > There shouldn't be a newline at all with the
> > actual functions bt_err or bt_info except
> > at the uses.
> then you might wanna read your patch again ;)

Yup, there's no newline with bt_info
and there shouldn't be one with bt_err
either.  There is though.  Oh well.
Easy to fix at your end if you like.


