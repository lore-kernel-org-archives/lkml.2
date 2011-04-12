Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1DLKMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:12:05 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:48498 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab1DLKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:12:03 -0400
Date: Tue, 12 Apr 2011 12:12:01 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Maxin John <maxin.john@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] cris/arch-v32: cryptocop: Use kzalloc
Message-ID: <20110412101201.GO16179@axis.com>
References: <AANLkTiksQLHDhHSBJG9Xj8n7Lykg9Jpxb3BS739LFEQP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiksQLHDhHSBJG9Xj8n7Lykg9Jpxb3BS739LFEQP@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 12:17:23PM +0200, Maxin John wrote:
> This avoids unnecessary explicit initialization by allocating zeroed memory.
> 
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>

Applied, thanks!

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
