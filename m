Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1JCElN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 00:41:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36324 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1JCElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 00:41:07 -0400
Date: Sun, 2 Oct 2011 23:40:55 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: unable to resolve reference refs/tags/v3.1-rc8: Success
Message-ID: <20111003044045.GA17289@elie>
References: <4E892483.7070605@lwfinger.net>
 <20111003035907.GA17134@elie>
 <4E8936F4.5060506@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8936F4.5060506@lwfinger.net>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:

> After applying that patch, I get
>
> finger@larrylap:~/linux-2.6> ~/git/git pull
> fatal: ref refs/tags/v3.1-rc8 is corrupt: length=41, content=

Great, thanks.

In the short term I'd suggest just removing the corrupt
.git/refs/tags/v3.1-rc8 file with "rm" so it can be fetched again.
Hopefully later tonight I can prepare a real patch to fix this, though
I wouldn't mind if someone else takes care of it first.
