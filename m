Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1BFB6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:58:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36845
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab1BFB57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:57:59 -0500
Date: Sat, 05 Feb 2011 17:58:35 -0800 (PST)
Message-Id: <20110205.175835.71108338.davem@davemloft.net>
To: ajit.khaparde@emulex.com
Cc: netdev@vger.kernel.org, jj@chaosbits.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ServerEngines, benet: Avoid potential null deref in
 be_cmd_get_seeprom_data()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110205031828.GA12772@akhaparde-VBox>
References: <20110205031828.GA12772@akhaparde-VBox>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajit Khaparde <ajit.khaparde@emulex.com>
Date: Fri, 4 Feb 2011 21:18:28 -0600

> [PATCH] ServerEngines, benet: Avoid potential null deref in be_cmd_get_seeprom_data()
> 
> Found by: Jesper Juhl <jj@chaosbits.net>
> 
> Signed-off-by: Ajit Khaparde <ajit.khaparde@emulex.com>

Applied, thanks.
