Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1FANJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:09:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6171 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1FANJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:09:26 -0400
Date: Wed, 1 Jun 2011 15:09:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
Message-ID: <20110601150915.4af71a0a@endymion.delvare>
In-Reply-To: <4DE3E9E7.8020008@zytor.com>
References: <4DE3E9E7.8020008@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 30 May 2011 12:03:03 -0700, H. Peter Anvin wrote:
> With the v3.0 name change I was looking over what might break, and I'm
> seriously considering turning off the incremental diff robot on
> kernel.org.  It's not clear to me that it is actually useful anymore,
> with git and all.
> 
> Do anyone actually use these anymore?

Do you mean files in testing/incr such as patch-2.6.39-rc6-rc7.bz2?
Yes, I am still using these. That being said:
* I guess I could extract these myself from git with a simple git
  diff command?
* I don't give a damn to older incremental patches, only to the ones of
  the current development cycle.

So if you want to delete all the old files, I'm all for it, and if you
decide to no longer generate the incremental patches at all, I can live
with it.

-- 
Jean Delvare
