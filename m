Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1EWHOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:14:21 -0400
Received: from linux-sh.org ([111.68.239.195]:47701 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1EWHOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:14:19 -0400
Date: Mon, 23 May 2011 16:13:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: Re: [PATCHv2] atomic: add *_dec_not_zero
Message-ID: <20110523071345.GL5206@linux-sh.org>
References: <1304458235-28473-1-git-send-email-sven@narfation.org> <1305748194-23351-1-git-send-email-sven@narfation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305748194-23351-1-git-send-email-sven@narfation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:49:54PM +0200, Sven Eckelmann wrote:
> This is actually the same patch as before, but I am still waiting for
> some (N)Acks for ia64, m32r, s390, sh and generic.
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
