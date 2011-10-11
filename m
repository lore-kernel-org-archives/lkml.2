Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1JKUpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:45:19 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:56498 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751898Ab1JKUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:45:17 -0400
Message-ID: <4E94AADA.4080204@xenotime.net>
Date: Tue, 11 Oct 2011 13:45:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for Oct 11 (iio/resolver)
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
In-Reply-To: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 02:11, Stephen Rothwell wrote:
> Hi all,
> 
> The linux-next tree is now available from
> git://github.com/sfrothwell/linux-next.git as a temporary measure while
> the kernel.org servers are unavailable.
> 
> It may also turn up on git.kernel.org (depending on the mirroring).  The
> patch set is still absent, however.
> 
> Changes since 20111007:

When no GPIO support is enabled:

drivers/staging/iio/resolver/ad2s1210.c:657:14: error: array type has incomplete element type
drivers/staging/iio/resolver/ad2s1210.c:665:44: warning: type defaults to 'int' in type name
drivers/staging/iio/resolver/ad2s1210.c:665:44: warning: type defaults to 'int' in type name
drivers/staging/iio/resolver/ad2s1210.c:665:44: error: negative width in bit-field '<anonymous>'
drivers/staging/iio/resolver/ad2s1210.c:671:14: error: array type has incomplete element type
drivers/staging/iio/resolver/ad2s1210.c:679:34: warning: type defaults to 'int' in type name
drivers/staging/iio/resolver/ad2s1210.c:679:34: warning: type defaults to 'int' in type name
drivers/staging/iio/resolver/ad2s1210.c:679:34: error: negative width in bit-field '<anonymous>'



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
