Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3ACLLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:11:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23306 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3ACLL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:11:28 -0500
Date: Thu, 3 Jan 2013 14:10:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Message-ID: <20130103111040.GD7247@mwanda>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
 <1355852048-23188-7-git-send-email-linux@prisktech.co.nz>
 <50D62BC9.9010706@mvista.com>
 <50E32C06.5020104@gmail.com>
 <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
 <1357104713.30504.8.camel@gitbox>
 <20130103090520.GC7247@mwanda>
 <20130103100000.GJ2631@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103100000.GJ2631@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Come on...  Don't say we haven't read comment.  Obviously, the first
thing we did was read that comment.  I've read it many times at this
point and I still think we should add in a bit which says:

"NOTE:  Drivers should treat the return value as an opaque cookie
and not dereference it.  NULL returns don't imply an error so don't
use IS_ERR_OR_NULL() to check for errors."

regards,
dan carpenter
