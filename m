Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2IQRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:25:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59629 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2IQRZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:25:24 -0400
Date: Mon, 17 Sep 2012 13:25:21 -0400 (EDT)
Message-Id: <20120917.132521.2171143815764276535.davem@davemloft.net>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xemul@parallels.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Subject: Re: [PATCH] tcp: restore rcv_wscale in a repair mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1347571687-3539973-1-git-send-email-avagin@openvz.org>
References: <1347571687-3539973-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>
Date: Fri, 14 Sep 2012 01:28:07 +0400

> This patch doesn't break a backward compatibility.
> If someone uses it in a old scheme, a rcv window
> will be restored with the same bug (rcv_wscale = 0).

The whole world is not little-endian.  This does in fact break
backwards compatability.

You will need to extend this in a more reasonable manner.
