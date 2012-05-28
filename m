Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2E1JfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:35:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50403 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2E1JfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:35:10 -0400
Date: Mon, 28 May 2012 12:34:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [staging] bcm: Fix codingstyle problems
Message-ID: <20120528093455.GY4637@mwanda>
References: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
 <CAKPrQY8O0=PQroL6vYOCATG3WUx1ChgqW9rFqhuY2G7Q7oj3WA@mail.gmail.com>
 <1338172734.977.3.camel@joe2Laptop>
 <CAHdPZaMbzWBUsaTKYiApnZxhaGRqSaaaHdpPtiYSKrFLrn0rdg@mail.gmail.com>
 <1338179859.2202.11.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338179859.2202.11.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 09:37:39PM -0700, Joe Perches wrote:
> On Mon, 2012-05-28 at 09:53 +0530, devendra.aaru wrote:
> But read the TODO file.  I'm not sure if
> there's any value in working on bcm at all.

The bcm driver is pretty crappy and can't maintain a connection for
very long but we don't have a replacement, so it's worth fixing.

In America Sprint was the only company doing WiMax and I think
they're moving away from it now.  But WiMax and this chip are used
in Africa.

regards,
dan carpenter

