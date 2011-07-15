Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1GORHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:07:31 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54245 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876Ab1GORHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:07:30 -0400
X-Sasl-enc: A0ZvC37q0SnEk1fZSudjLL3/ionyKatTZYPvXdM6U8yr 1310749648
Date: Fri, 15 Jul 2011 19:06:21 +0200
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] gma500: Cursor interface
Message-ID: <20110715170621.GA6867@kroah.com>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this series applied, I get:
	drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory

:(
