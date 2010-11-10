Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0KJUw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:52:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36045
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560Ab0KJUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:52:57 -0500
Date: Wed, 10 Nov 2010 12:53:21 -0800 (PST)
Message-Id: <20101110.125321.179944968.davem@davemloft.net>
To: mk@lab.zgora.pl
Cc: sri@us.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix header size check for GSO case in recvmsg
 (af_packet)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289253525-7020-1-git-send-email-mk@lab.zgora.pl>
References: <1289253525-7020-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <mk@lab.zgora.pl>
Date: Mon,  8 Nov 2010 22:58:45 +0100

> Parameter 'len' is size_t type so it will never get negative.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Applied, thank you!
