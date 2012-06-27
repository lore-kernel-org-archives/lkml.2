Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2F0KF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:05:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41123 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2F0KF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:05:56 -0400
Date: Wed, 27 Jun 2012 03:05:53 -0700 (PDT)
Message-Id: <20120627.030553.595987698091598621.davem@davemloft.net>
To: annie.li@oracle.com
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Ian.Campbell@citrix.com, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com
Subject: Re: [Xen-devel] [PATCH 1/1] xen/netback: only non-freed SKB is
 queued into tx_queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340790355-16838-1-git-send-email-annie.li@oracle.com>
References: <1340790355-16838-1-git-send-email-annie.li@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Networking patches need to be sent to netdev@vger.kernel.org
