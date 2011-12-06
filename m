Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1LFSC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:02:28 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:51016 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1LFSC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:02:26 -0500
Message-ID: <4EDE58AA.8090305@gentoo.org>
Date: Tue, 06 Dec 2011 19:02:18 +0100
From: =?ISO-8859-1?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, 649468@bugs.debian.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] alpha: add io{read,write}{16,32}be functions
References: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz>
In-Reply-To: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 09:01 AM, Michael Cree wrote:
> These functions are used in some PCI drivers with big-endian
> MMIO space.
> 
> Admittedly it is almost certain that no one this side of the
> Moon would use such a card in an Alpha but it does get us
> closer to being able to build allyesconfig or allmodconfig,
> and it enables the Debian default generic config to build.
> 
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
[snip]

WFM on my DS20E using 3.2.0-rc4-00231-g958c6c2

so,

Tested-by: Raúl Porcel <armin76@gentoo.org>
