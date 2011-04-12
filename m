Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1DLXVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:21:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867Ab1DLXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:21:11 -0400
Date: Tue, 12 Apr 2011 16:20:36 -0700 (PDT)
Message-Id: <20110412.162036.241924043.davem@davemloft.net>
To: bp@amd64.org
Cc: romieu@fr.zoreil.com, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Be verbose when unable to load fw patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302615172-1646-1-git-send-email-bp@amd64.org>
References: <1302615172-1646-1-git-send-email-bp@amd64.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>
Date: Tue, 12 Apr 2011 15:32:52 +0200

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> When the driver fails loading the firmware, it doesn't say which patch
> exactly it is missing. We have three different firmware images depending
> on the hw revision, so mention the exact patch name it is unable to load
> in the warning message.
> 
> Cc: Francois Romieu <romieu@fr.zoreil.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Seems reasonable, Francois?
