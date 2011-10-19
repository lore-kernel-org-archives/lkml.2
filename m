Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1JSWqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:46:24 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:52002 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1JSWqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:46:23 -0400
Date: Thu, 20 Oct 2011 00:43:12 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: fix wrong eee setting for rlt8111evl
Message-ID: <20111019224312.GA10574@electric-eye.fr.zoreil.com>
References: <1318572877-1549-1-git-send-email-hayeswang@realtek.com> <20111019.165742.1621277627528277376.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019.165742.1621277627528277376.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> :
> > Correct the wrong parameter for setting EEE for RTL8111E-VL.
> > 
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> Francois, want me to apply this directly or will you handle it?

Please apply it directly. I must trust Hayes on this one.

-- 
Ueimor
