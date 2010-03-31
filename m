Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab0CaGrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:47:13 -0400
Received: from isilmar.linta.de ([213.133.102.198]:60069 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932768Ab0CaGrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:47:10 -0400
Date: Wed, 31 Mar 2010 08:47:07 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
       Eric Miao <eric.y.miao@gmail.com>, Wolfram Sang <w.sang@pengutronix.de>,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Dmitry Artamonow <mad_soft@inbox.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] ARM: pcmcia: Adds nanoEngine PCMCIA support.
Message-ID: <20100331064707.GA11428@isilmar.linta.de>
Mail-Followup-To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
	Russell King <linux@arm.linux.org.uk>,
	Ralf Baechle <ralf@linux-mips.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	Wolfram Sang <w.sang@pengutronix.de>,
	Manuel Lauss <manuel.lauss@gmail.com>,
	Dmitry Artamonow <mad_soft@inbox.ru>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pcmcia@lists.infradead.org
References: <1269972879-27400-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269972879-27400-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 03:14:39PM -0300, Marcelo Roberto Jimenez wrote:
> This patch adds nanoEngine PCMCIA support, with support for two sockets.
> 
> In order to have a fully functional pcmcia subsystem in a BSE nanoEngine board
> you should carefully read this:
> 
> http://cambuca.ldhs.cetuc.puc-rio.br/nanoengine/

That website still talks about pcmcia-cs ... which was superseded by
pcmciautils.

The patch gets an

	Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

as I assume that Russell prefers to take it into his tree?

Best,
	Dominik
