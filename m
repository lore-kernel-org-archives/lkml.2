Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2FKIRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:17:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59179 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2FKIRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:17:13 -0400
Message-ID: <1339402702.4999.15.camel@lappy>
Subject: Re: [PATCH] ieee802154: verify packet size before trying to
 allocate it
From: Sasha Levin <levinsasha928@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: dbaryshkov@gmail.com, slapin@ossfans.org,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Jun 2012 10:18:22 +0200
In-Reply-To: <20120610.200443.971015025499077057.davem@davemloft.net>
References: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
	 <20120610.200443.971015025499077057.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-10 at 20:04 -0700, David Miller wrote:
> From: Sasha Levin <levinsasha928@gmail.com>
> Date: Sun, 10 Jun 2012 13:10:19 +0200
> 
> > Currently when sending data over datagram, the send function will attempt to
> > allocate any size passed on from the userspace.
> > 
> > We should make sure that this size is checked and limited. The maximum size
> > of an IP packet seemed like the safest limit here.
> > 
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> Why not limit to the device MTU?  That's exactly what I suggested
> to you.

That's what I ended up doing in the reply to this mail.

