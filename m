Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1GEV3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 17:29:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329Ab1GEV3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 17:29:40 -0400
Date: Tue, 5 Jul 2011 14:28:58 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: "David S. Miller" <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: possible bridge regression in "bridge: implement
 [add/del]_slave ops"?
Message-ID: <20110705142858.3b7e5941@nehalam.ftrdhcpuser.net>
In-Reply-To: <201106301033.23997.alexander.stein@systec-electronic.com>
References: <201106301033.23997.alexander.stein@systec-electronic.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just put a fix for the detection of bridge pseudo-device being up
into the current rstp code available at:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/rstp.git
