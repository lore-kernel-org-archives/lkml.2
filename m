Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899Ab2EITrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:47:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42722 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760815Ab2EITrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:47:09 -0400
Date: Wed, 09 May 2012 15:45:58 -0400 (EDT)
Message-Id: <20120509.154558.1469429813580317150.davem@davemloft.net>
To: wolfgang.walter@stwm.de
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.3.x: e1000 and ixgbe hang
From: David Miller <davem@davemloft.net>
In-Reply-To: <201205091857.14406.wolfgang.walter@stwm.de>
References: <201205091107.11820.wolfgang.walter@stwm.de>
	<20120509.120546.788906941073754076.davem@davemloft.net>
	<201205091857.14406.wolfgang.walter@stwm.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 May 2012 12:46:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Walter <wolfgang.walter@stwm.de>
Date: Wed, 9 May 2012 18:57:13 +0200

> But when we are at it: I think that when a bug in a stable kernel is
> found and the final fix is known it is bad practice to hord that
> patch till submission without letting stable@ know about it.

I think you have no idea what goes into vetting patches for -stable.

It can take me days to put together a series, and also I time my
-stable submissions with when Linus pulls my 'net' bug fixes into his
tree since a part of the -stable requirements is presence in Linus's
tree.

I therefore batch, because bleeding out individual fixes one by one to
-stable rarely, if ever, makes sense.

And another part of what goes into vetting a patch is time.  The
longer a patch sits in a non-stable tree getting tested, the more
likely any unwanted bugs and side effects will be caught before the
patch goes into -stable.

And finally I am under no obligation whatsoever to post some kind of
status report to -stable every few days saying when I'll do this or
that.
