Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2E1PCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:02:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56223 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501Ab2E1PCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:02:34 -0400
Message-ID: <1338217353.2202.26.camel@joe2Laptop>
Subject: Re: [PATCH] [staging] bcm: Fix codingstyle problems
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 28 May 2012 08:02:33 -0700
In-Reply-To: <20120528093455.GY4637@mwanda>
References: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
	 <CAKPrQY8O0=PQroL6vYOCATG3WUx1ChgqW9rFqhuY2G7Q7oj3WA@mail.gmail.com>
	 <1338172734.977.3.camel@joe2Laptop>
	 <CAHdPZaMbzWBUsaTKYiApnZxhaGRqSaaaHdpPtiYSKrFLrn0rdg@mail.gmail.com>
	 <1338179859.2202.11.camel@joe2Laptop> <20120528093455.GY4637@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-28 at 12:34 +0300, Dan Carpenter wrote:
> On Sun, May 27, 2012 at 09:37:39PM -0700, Joe Perches wrote:
> > On Mon, 2012-05-28 at 09:53 +0530, devendra.aaru wrote:
> > But read the TODO file.  I'm not sure if
> > there's any value in working on bcm at all.
> 
> The bcm driver is pretty crappy and can't maintain a connection for
> very long but we don't have a replacement, so it's worth fixing.

Well, the patch I suggested drops the size by 25%/100K
so it's probably worth something.

$ size drivers/staging/bcm/*.ko*
   text	   data	    bss	    dec	    hex	filename
 260530	   7248	  53632	 321410	  4e782	drivers/staging/bcm/bcm_wimax.ko.new
 338001	   7192	  84888	 430081	  69001	drivers/staging/bcm/bcm_wimax.ko.old


