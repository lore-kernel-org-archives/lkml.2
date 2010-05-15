Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0EOOY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:24:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37152 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0EOOYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:24:55 -0400
Date: Sat, 15 May 2010 15:24:10 +0100
From: Russell King <rmk+pcmcia@arm.linux.org.uk>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] pcmcia: disable pcmcia ioctl for !ARM, prepare for
	removal
Message-ID: <20100515142409.GB18960@flint.arm.linux.org.uk>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-pcmcia@lists.infradead.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org
References: <20100303075944.GA23354@comet.dominikbrodowski.net> <1267603248-23866-5-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267603248-23866-5-git-send-email-linux@dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 09:00:48AM +0100, Dominik Brodowski wrote:
> Furthermore, the last legitimate use of the ioctl to be reported
> relates to the ARM architecture in 2008.[1] Attempts to resolve
> this issue turned out unsuccessful so far.[2] Other usages have only
> been reported as hear-say. If there are any legitiate and necessary
> use-cases remaining, please speak out before the end of the grace
> period until 2.6.3{5,6}(-rc1).

What's the point of speaking out?  You don't take any notice of people
who do, and you continue your crusade of wanting to remove it.  Please,
stop giving the impression that you give a damn of what people say about
the ioctl interface.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
