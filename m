Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab2DRHLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:11:44 -0400
Received: from sous-sol.org ([216.99.217.87]:43834 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2DRHLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:11:43 -0400
Date: Wed, 18 Apr 2012 00:10:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Remy Bohmer <linux@bohmer.net>,
        Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH-v4] Support M95040 SPI EEPROM
Message-ID: <20120418071040.GB31135@sequoia.sous-sol.org>
References: <1334730574-31911-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334730574-31911-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ivo Sieben (meltedpianoman@gmail.com) wrote:
> Updated the generic SPI EEPROM driver AT25 for support of an additional address
> bit in the instruction byte. Certain EEPROMS have a size that is larger than the
> number of address bytes would allow (e.g. like M95040 from ST that has 512 Byte
> size but uses only one address byte (A0 to A7) for addressing.) For the extra
> address bit (A8, A16 or A24) bit 3 of the instruction byte is used. This
> instruction bit is normally defined as don't care for other AT25 like chips.
> 
> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
