Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1DOFEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:04:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34171
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab1DOFEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:04:36 -0400
Date: Thu, 14 Apr 2011 22:04:01 -0700 (PDT)
Message-Id: <20110414.220401.112603574.davem@davemloft.net>
To: decot@google.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net-bonding: Fix minor/cosmetic type
 inconsistencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302744151-12452-2-git-send-email-decot@google.com>
References: <1302744151-12452-1-git-send-email-decot@google.com>
	<1302744151-12452-2-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aFrom: David Decotigny <decot@google.com>
Date: Wed, 13 Apr 2011 18:22:30 -0700

> The __get_link_speed() function returns a u16 value which was stored
> in a u32 local variable. This patch uses the return value directly,
> thus fixing that minor type consistency.
> 
> The 'duplex' field in struct slave being encoded on 8 bits, to be more
> consistent we use a u8 integer (instead of u16) whenever we copy it to
> local variables.
> 
> Signed-off-by: David Decotigny <decot@google.com>

Applied.
