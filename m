Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab0FBUpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:45:05 -0400
Received: from usul.saidi.cx ([204.11.33.34]:52842 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758027Ab0FBUpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:45:03 -0400
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: strange problem with ricoh-mmc
MIME-Version: 1.0
Date: Wed, 02 Jun 2010 16:42:33 -0400
From: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1275509965.6277.5.camel@maxim-laptop>
References: <1275505018.4215.10.camel@maxim-laptop> <04b98a3f757587ee9b72f2e28e257b50@localhost> <1275509965.6277.5.camel@maxim-laptop>
Message-ID: <b7d3349cdb8e4c118d617ef9df57bf69@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 02 Jun 2010 23:19:25 +0300, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> 
> Thanks.
> I some future I maybe consider reverse engineering  the MMC controller.

Someone actually did, if you dig back through the SDHCI mailing list. It's
apparently almost identical to SDHCI with the Cap flags not set properly.

http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html

Still, even if we got it working properly, it would be rather less elegant
than what we have today, modulo hardware freaking out as you are
experiencing...

--phil
