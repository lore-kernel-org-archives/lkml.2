Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374Ab0GSJ04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 05:26:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6695 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760298Ab0GSJ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 05:26:56 -0400
Date: Mon, 19 Jul 2010 11:26:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: failed import of the i2c quilt series
Message-ID: <20100719112646.12d35b56@hyperion.delvare>
In-Reply-To: <20100713102736.b66c2c2f.sfr@canb.auug.org.au>
References: <20100713102736.b66c2c2f.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 13 Jul 2010 10:27:36 +1000, Stephen Rothwell wrote:
> Importing of the i2c quilt tree this morning produced this error:
> 
> i2c-drop-preliminary-probability-checks.patch
> error: patch failed: drivers/i2c/i2c-core.c:1456
> error: drivers/i2c/i2c-core.c: patch does not apply
> 
> I will use the i2c tree from next-20100712 for today.

Probably caused by me not being quick enough to remove the patches from
my queue after Linus merged them (I was travelling.) Should be fixed by
now.

-- 
Jean Delvare
