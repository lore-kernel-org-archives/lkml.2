Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590Ab0COSFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:05:54 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:36072 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385Ab0COSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:05:53 -0400
Date: Mon, 15 Mar 2010 20:06:15 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv2] USB: composite: allow optional removal of __init and
 __exit tags
Message-ID: <20100315180615.GC3857@gandalf>
Reply-To: me@felipebalbi.com
References: <94ae17705a23aec612042afcc34c44f993088eca.1268307147.git.mina86@mina86.com>
 <1865d3ee9a5ca4e41844577fff9e01e63427ed71.1268656947.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1865d3ee9a5ca4e41844577fff9e01e63427ed71.1268656947.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 01:48:18PM +0100, Michal Nazarewicz wrote:
> The composite framework has been written using __init and __exit tags
> to mark init and exit functions as such.  This works with most of the
> composite gadgets however some may need to call init/exit functions
> during normal operations.  One example is mass storage gadget which
> needs to call exit functions.
> 
> This patch allows gadgets to define USB_NO_INIT_SEGMENT or
> USB_NO_EXIT_SEGMENT to remove the __init and __exit declarations
> from composite framework.

wouldn't it be the same as changing from __init to __devinit and __exit
to __devexit ??

-- 
balbi
