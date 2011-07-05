Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1GETKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:10:31 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:55294 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab1GETK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:10:29 -0400
Date: Tue, 5 Jul 2011 20:56:26 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] r8169: support RTL8111E-VL
Message-ID: <20110705185626.GF5105@electric-eye.fr.zoreil.com>
References: <1309859095-32031-1-git-send-email-hayeswang@realtek.com> <1309859095-32031-6-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309859095-32031-6-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
[...]
> +	rtl_writephy(tp, 0x1e, 0x002D);
                                   ^^ 2d :o)

Some rtl_eri_write probably deserve to be tabulated. It can wait though.

-- 
Ueimor
