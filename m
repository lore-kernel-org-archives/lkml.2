Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2LMSEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:04:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52782 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2LMSD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:03:59 -0500
Date: Thu, 13 Dec 2012 18:03:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH 04/26] arm64: Convert print_symbol to %pSR
Message-ID: <20121213180348.GD16532@arm.com>
References: <cover.1355335227.git.joe@perches.com>
 <c5cb06461153912fe383547a267aaea6e8b4976a.1355335227.git.joe@perches.com>
MIME-Version: 1.0
In-Reply-To: <c5cb06461153912fe383547a267aaea6e8b4976a.1355335227.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Dec 2012 18:03:55.0796 (UTC) FILETIME=[37ADAD40:01CDD95C]
X-MC-Unique: 112121318035702101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 06:18:53PM +0000, Joe Perches wrote:
> Use the new vsprintf extension to avoid any possible
> message interleaving.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

