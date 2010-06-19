Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0FSRUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:20:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:35017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0FSRUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:20:41 -0400
Date: Sat, 19 Jun 2010 10:17:01 -0700
From: Greg KH <gregkh@suse.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 19/26] USB: Add JZ4740 ohci support
Message-ID: <20100619171701.GA28151@suse.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
 <1276924111-11158-20-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276924111-11158-20-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 07:08:24AM +0200, Lars-Peter Clausen wrote:
> This patch adds ohci glue code for JZ4740 SoCs ohci module.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: linux-usb@vger.kernel.org

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

