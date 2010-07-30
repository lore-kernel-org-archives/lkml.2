Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab0G3WUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:20:04 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:45596 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0G3WUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:20:01 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C534C9D.8000600@tuxonice.net>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 08:19:57 +1000
Message-ID: <1280528398.2642.3.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 08:05 +1000, Nigel Cunningham wrote:
> In general, it looks good. Is an order 6 allocation really necessary, 
> though?

To be honest, I don't really know. I kinda guessed that the more data
compress routine has, the more it's going to be able to squeeze it down.
I can do some tests with 5 or even 4. Will let you know.

-- 
Bojan

