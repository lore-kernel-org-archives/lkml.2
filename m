Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0EUWCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:02:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48831
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab0EUWCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:02:45 -0400
Date: Fri, 21 May 2010 15:02:53 -0700 (PDT)
Message-Id: <20100521.150253.149682718.davem@davemloft.net>
To: James.Bottomley@suse.de
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: bug fix patch lost: git problem or just incorrect merge?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274456515.9022.14.camel@mulgrave.site>
References: <1274456515.9022.14.camel@mulgrave.site>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>
Date: Fri, 21 May 2010 10:41:55 -0500

> Is this a git problem ... or is it just a mismerge in the net tree?

Mismerge, because sk->sk_sleep() doesn't exist any more I mistakenly
updated the original line to do the sk_sleep() stuff.

Sorry about that.
