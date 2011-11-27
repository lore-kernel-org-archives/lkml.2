Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1K0KG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:06:57 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39324 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab1K0KGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:06:55 -0500
X-Sasl-enc: eM+fm3wkXdSBWVWAqUAQ2wqPbxkuk5O1vTIt/MUzofYn 1322388413
Date: Sat, 26 Nov 2011 18:52:52 -0800
From: Greg KH <greg@kroah.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>, Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <gregory.dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH v3] comedi: integer overflow in do_insnlist_ioctl()
Message-ID: <20111127025252.GA29073@kroah.com>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
 <20111123061355.GA3295@mwanda>
 <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
 <20111123145020.GA3258@mwanda>
 <4ECD1A01.3060503@mev.co.uk>
 <4ECD6873.7080106@metafoo.de>
 <20111123215111.GD3258@mwanda>
 <97189E06-26D8-4CF9-B325-06403FB1C42C@gmail.com>
 <20111125072550.GK3195@mwanda>
 <4ED00CCB.80604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED00CCB.80604@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 04:46:51PM -0500, Xi Wang wrote:
> There is a potential integer overflow in do_insnlist_ioctl() if
> userspace passes in a large insnlist.n_insns.  The call to kmalloc()
> would allocate a small buffer, leading to a memory corruption.
> 
> The bug was reported by Dan Carpenter <dan.carpenter@oracle.com>
> and Haogang Chen <haogangchen@gmail.com>.  The patch was suggested by
> Ian Abbott <abbotti@mev.co.uk> and Lars-Peter Clausen <lars@metafoo.de>.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Hm, I already applied Dan's previous patch, what should I do with this
one now?  Revert Dan's and apply this one, or apply both of them, or
something else?

confused,

greg k-h
