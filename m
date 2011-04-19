Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1DSFrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 01:47:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53390
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab1DSFrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 01:47:18 -0400
Date: Mon, 18 Apr 2011 22:46:42 -0700 (PDT)
Message-Id: <20110418.224642.71106517.davem@davemloft.net>
To: decot@google.com
Cc: jes@trained-monkey.org, linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acenic: Fix using the specified speed when configuring
 NIC
From: David Miller <davem@davemloft.net>
In-Reply-To: <1303001827-4283-1-git-send-email-decot@google.com>
References: <1303001827-4283-1-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Sat, 16 Apr 2011 17:57:07 -0700

> This patch needs review, as I did not test it: I only think something
> is weird by looking at the code, but experts must confirm.
> 
> This tells the NIC to take the speed specified by ethtool into account
> when configuring the NIC, instead of keeping the previous speed.
> 
> Signed-off-by: David Decotigny <decot@google.com>

Looks correct, but seems to be dependent upon some other patches which
have feedback pending which you need to address.

Please resubmit that when the other series ends up being applied after
you've fixed it up.
