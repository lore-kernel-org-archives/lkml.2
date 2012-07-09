Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2GIUkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:40:22 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:58860 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2GIUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:40:17 -0400
Date: Mon, 9 Jul 2012 22:28:28 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.4.4 r8169 weirdness
Message-ID: <20120709202828.GA20338@electric-eye.fr.zoreil.com>
References: <4FFB13E6.40904@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFB13E6.40904@xs4all.nl>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> :
[...]
> Is my hardware dying or is it the kernel?

Try adding eb2dc35d99028b698cdedba4f5522bc43e576bd2 if you own a 8168evl.

If you don't, try reverting 036dafa28da1e2565a8529de2ae663c37b7a0060.

-- 
Ueimor
