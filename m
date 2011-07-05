Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1GETJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:09:58 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:55291 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab1GETJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:09:55 -0400
Date: Tue, 5 Jul 2011 20:55:52 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] r8169: fix wake on lan setting for 8111E
Message-ID: <20110705185552.GE5105@electric-eye.fr.zoreil.com>
References: <1309859095-32031-1-git-send-email-hayeswang@realtek.com> <1309859095-32031-5-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309859095-32031-5-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> Only 8111E needs enable RxConfig bit 0 ~ 3 when suspending or
> shutdowning when supporting wake on lan.

Nit: if it only applies to the non-VL 8111E, it could make sense to apply
it after the 8168E-VL support patch and outline this fact in the comment.

Your call.

-- 
Ueimor
