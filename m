Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1JNOFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:05:19 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:42340 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1JNOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:05:18 -0400
Subject: Re: [PATCH 21/21] cris: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111014133354.GE9412@axis.com>
References: <1318595467.6132.80.camel@x61.thuisdomein>
	 <20111014133354.GE9412@axis.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 16:05:15 +0200
Message-ID: <1318601115.6132.86.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 15:33 +0200, Jesper Nilsson wrote:
> Hmmm... NAK on that. Lots of these configs are actually used, but in drivers
> not upstream yet (serial port, ethernet and usb drivers for ARTPEC-3).

Since I'm not involved in cris development - not involved in cris in any
way, actually - I determined what's used now by looking what's in the
mainline tree now. When are those drivers expected to be in the mainline
tree?


Paul  Bolle

