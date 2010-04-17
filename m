Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab0DQWo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 18:44:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33390
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465Ab0DQWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 18:44:26 -0400
Date: Sat, 17 Apr 2010 15:44:29 -0700 (PDT)
Message-Id: <20100417.154429.214216438.davem@davemloft.net>
To: cesarb@cesarb.net
Cc: linux-kernel@vger.kernel.org, aeb@cwi.nl, fabbione@ubuntu.com
Subject: Re: [PATCH] fs/partitions: use ADDPART_FLAG_RAID instead of magic
 number
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271543289-25833-1-git-send-email-cesarb@cesarb.net>
References: <1271543289-25833-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cesar Eduardo Barros <cesarb@cesarb.net>
Date: Sat, 17 Apr 2010 19:28:09 -0300

> ADDPART_FLAG_RAID was introduced in commit d18d768, and most places were
> converted to use it instead of a hardcoded value. However, some places seem
> to have been missed.
> 
> Change all of them to the symbolic names via the following semantic patch:
 ...
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Acked-by: David S. Miller <davem@davemloft.net>
