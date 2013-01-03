Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3ACNxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:53:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39286 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3ACNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:53:18 -0500
Date: Thu, 3 Jan 2013 13:52:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Dan Carpenter <error27@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
	IS_ERR_OR_NULL
Message-ID: <20130103135256.GO2631@n2100.arm.linux.org.uk>
References: <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com> <1357104713.30504.8.camel@gitbox> <20130103090520.GC7247@mwanda> <20130103100000.GJ2631@n2100.arm.linux.org.uk> <20130103111040.GD7247@mwanda> <20130103112102.GM2631@n2100.arm.linux.org.uk> <20130103134554.GJ7247@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103134554.GJ7247@mwanda>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:45:54PM +0300, Dan Carpenter wrote:
> On Thu, Jan 03, 2013 at 11:21:02AM +0000, Russell King - ARM Linux wrote:
> > Maybe you don't realise, but IS_ERR(NULL) is false.  Therefore, this falls
> > into category (2).
> 
> No, obviously, I know the difference between IS_ERR() and
> IS_ERR_OR_NULL().  That's how we started this thread.

Well, if you know that, then how is the documentation anything _but_
clear?
