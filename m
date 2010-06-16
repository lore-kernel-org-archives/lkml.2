Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab0FPVri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:47:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58592
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954Ab0FPVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:47:37 -0400
Date: Wed, 16 Jun 2010 14:47:48 -0700 (PDT)
Message-Id: <20100616.144748.179940335.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: hadi@cyberus.ca, tom@compton.nu, netdev@vger.kernel.org,
       akpm@linux-foundation.org, shemminger@vyatta.com, kaber@trash.net,
       tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clear IFF_XMIT_DST_RELEASE for teql interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276697660.2632.79.camel@edumazet-laptop>
References: <1276676668-10256-1-git-send-email-tom@compton.nu>
	<1276694745.3862.1.camel@bigi>
	<1276697660.2632.79.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 16 Jun 2010 16:14:20 +0200

> Please David, could you add bugzilla entry in commit ?
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16183
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Done and applied, thanks everyone.
