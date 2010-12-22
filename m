Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0LVT4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 14:56:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34580
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0LVT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 14:56:52 -0500
Date: Wed, 22 Dec 2010 11:57:21 -0800 (PST)
Message-Id: <20101222.115721.39176015.davem@davemloft.net>
To: jkosina@suse.cz
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012172310400.16569@pobox.suse.cz>
	<alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, 22 Dec 2010 11:00:39 +0100 (CET)

> Besides that, any comments on this, please?

It's in my backlog, patience is a virtue.
