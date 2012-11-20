Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2KTPvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:51:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2KTPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:51:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH 2/2] ARC: provide optimal __get_user_fn()
Date: Tue, 20 Nov 2012 15:51:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1353422297-29079-1-git-send-email-vgupta@synopsys.com> <1353422297-29079-3-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1353422297-29079-3-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211201551.43791.arnd@arndb.de>
X-Provags-ID: V02:K0:0tA5IWZoZ5JJJHe0BXsua344CS5AZiVJcpaT9jn0L6o
 MC9mz5J1Xj+pkL/CiJK1vnqT1Pu0GmcKq4eiHArNJ33ZTVar45
 KIWtkvgGjV2C84pAbdHPMmhmZRBMFML1vIML4hwPZsfDMYjXkz
 7IWfrOpg/0Mi0j1AjMZk5gCGzTipqpKaAagG2RhC4aqheYfDLc
 LgZPir26p1i9oWWnTlt4rf8VlUg6HuLITZk0oBHxqf+mUYjbtH
 S6cTari0l0KKJbz3Pzi+dwCewEnsq+ujfaNDfLKffGCM/zwqAE
 YwsD5yy24WOEsvU0sCkC/wSiLPhonLpdjbBQsMwHnA5AgqSR93
 DdyoM7y+NsSkeA4/fisI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012, Vineet.Gupta1@synopsys.com wrote:
> From: Vineet Gupta <vgupta@synopsys.com>
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Yes, this looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
