Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0IGB3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:29:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50285
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab0IGB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:29:30 -0400
Date: Mon, 06 Sep 2010 18:29:47 -0700 (PDT)
Message-Id: <20100906.182947.258128485.davem@davemloft.net>
To: jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, netdev@vger.kernel.org,
        ddutt@brocade.com, rmody@brocade.com
Subject: Re: [PATCH 1/1] NET: bna, fix lock imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283602121-11443-1-git-send-email-jslaby@suse.cz>
References: <1283602121-11443-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Sat,  4 Sep 2010 14:08:41 +0200

> bnad_set_rx_mode omit to unlock bna_lock on one fail path. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied.
