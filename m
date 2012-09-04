Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab2IDM1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:27:03 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18519 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab2IDM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:27:02 -0400
Date: Tue, 4 Sep 2012 05:25:44 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Manavendra Nath Manav <mnm.kernel@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
Message-ID: <20120904122544.GC19396@mwanda>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
 <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:58:20PM +0530, Manavendra Nath Manav wrote:
> Is the above a genuine kernel bug, or i am missing something out here. Pls help.
> 

When you declare something as const then the compiler assumes it
really is const and uses a literal instead of reading from memory.
I'm surprised the compiler doesn't print a warning message.

It has to do with compilers, nothing to do with kernels.

regards,
dan carpenter
