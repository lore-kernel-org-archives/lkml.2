Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1GRHc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:32:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29119 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1GRHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:32:56 -0400
Date: Mon, 18 Jul 2011 09:32:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: failure importing the jdelvare-hwmon tree
Message-ID: <20110718093245.70045e57@endymion.delvare>
In-Reply-To: <20110718104646.c6b59b75792a1688d079fa28@canb.auug.org.au>
References: <20110718104646.c6b59b75792a1688d079fa28@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 10:46:46 +1000, Stephen Rothwell wrote:
> Importing the jdelvare-hwmon tree failed like this:
> 
> $ git am ../quilt/jdelvare-hwmon/hwmon-max1111-improve-memory-usage.patch
> Applying: hwmon: (max1111) Avoid extra memory allocations
> error: patch failed: drivers/hwmon/max1111.c:224
> error: drivers/hwmon/max1111.c: patch does not apply
> Patch failed at 0001 hwmon: (max1111) Avoid extra memory allocations
> 
> I fixed up the patch ('&' needed in call to mutex_destroy).

D'oh. Sorry again, fixed now.

It's about time that I take a long vacation break, apparently.

-- 
Jean Delvare
