Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267Ab0KQSog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:44:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758464Ab0KQSof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:44:35 -0500
Date: Wed, 17 Nov 2010 10:44:59 -0800 (PST)
Message-Id: <20101117.104459.115933389.davem@davemloft.net>
To: joe@perches.com
Cc: trivial@kernel.org, ramkrishna.vepa@exar.com, sivakumar.subramani@exar.com,
        sreenivasa.honnur@exar.com, jon.mason@exar.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] drivers/net/vxge: Remove unnecessary casts of
 netdev_priv
From: David Miller <davem@davemloft.net>
In-Reply-To: <5aee4bf89b5baa6e1d32c99be560893925ed2e19.1289855436.git.joe@perches.com>
References: <cover.1289855436.git.joe@perches.com>
	<5aee4bf89b5baa6e1d32c99be560893925ed2e19.1289855436.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 15 Nov 2010 13:12:30 -0800

> Signed-off-by: Joe Perches <joe@perches.com>

Applied.

VXGE folks, note that this means any patches you send to me need
to take Joe's changes into account.  If you diff against current
net-next-2.6 you'll be fine.
