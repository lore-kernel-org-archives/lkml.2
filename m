Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423671Ab2KOMrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:47:17 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46200 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423250Ab2KOMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:47:15 -0500
X-Sasl-enc: GXj+tMhPMOWOslhNQRHd1sYUXNXiYLqmegyoZ4g4cerG 1352983635
Date: Thu, 15 Nov 2012 10:47:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/Sandy Bridge: reserve pages when integrated graphics
 is present
Message-ID: <20121115124711.GA31504@khazad-dum.debian.net>
References: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Jesse Barnes wrote:
> +		unsigned long bad_ranges[] = {
> +			0x20050000,
> +			0x20110000,
> +			0x20130000,
> +			0x20138000,
> +			0x40004000,

Yikes.  Can this be fixed through a microcode update?  The kernel would
still need the workaround anyway, but at least you would be able to be quite
heavy-handed on it, and users could be warned of a better fix...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
