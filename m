Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0CYKdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:33:53 -0400
Received: from stinky.trash.net ([213.144.137.162]:48665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0CYKdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:33:51 -0400
Message-ID: <4BAB3C0D.4080906@trash.net>
Date: Thu, 25 Mar 2010 11:33:49 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Netfilter: Code cleanup on net/netfilter
References: <20100325092154.GB29056@localhost.localdomain>
In-Reply-To: <20100325092154.GB29056@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wzt.wzt@gmail.com wrote:
> Fix some coding styles and remove moduleparam.h

I've already applied your patches to remove moduleparam.h.
Please base your patches on

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
