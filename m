Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2CLRC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:02:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2CLRCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:02:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
Date: Mon, 12 Mar 2012 17:02:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
References: <20120312002046.041448832@1wt.eu>
In-Reply-To: <20120312002046.041448832@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203121702.06598.arnd@arndb.de>
X-Provags-ID: V02:K0:a3ydpdbP0eCmETdE/qXZ4BFijZzIjALw4Xjs4Md9/Qx
 3kEzZAQYDyJIR6B0uZ7+qltMSEUcvANz4X3pQdMZj3XEvUHNuE
 OsuWosVQetDhyS0N23PNebJzNENitwnhDgzgiwCS+jZkCb1IFo
 9lN1XiQYrTXqNvqPvklWpWpF45xFFZ05x0R593LaeVWHKeHUao
 8ELYi4XQFCPWUKf1cY7g3K3PpJdzZMkDIcocDqSyXMuGSXDNnn
 vL0qrf6DbrNLr+ixW00NKd6/PFcwx2Am+yndy20BxsifDHLcW3
 rP+se0m2g1qfxH4loHV9BFf+8E5P/ACuH+jTknE5h7YEdAHQii
 6xg7D+t3vixMDyZBfMp8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, Willy Tarreau wrote:
> 
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream
> 
> This just changes Kconfig rather than touching all the other files the
> original commit did.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I think it would be useful to copy the entire description of the
original patch here, which makes it clear why it's a good idea
to apply this patch to 2.6.32-longterm.

	Arnd
