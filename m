Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1JLI6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:58:20 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:53654 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1JLI6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:58:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9556A2.9050005@cam.ac.uk>
Date: Wed, 12 Oct 2011 09:58:10 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-iio@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for Oct 11 (iio/resolver)
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au> <4E94AADA.4080204@xenotime.net>
In-Reply-To: <4E94AADA.4080204@xenotime.net>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 21:45, Randy Dunlap wrote:
> On 10/11/11 02:11, Stephen Rothwell wrote:
>> Hi all,
>>
>> The linux-next tree is now available from
>> git://github.com/sfrothwell/linux-next.git as a temporary measure while
>> the kernel.org servers are unavailable.
>>
>> It may also turn up on git.kernel.org (depending on the mirroring).  The
>> patch set is still absent, however.
>>
>> Changes since 20111007:
> 
> When no GPIO support is enabled:
Thanks Randy. Fix is clearly to add the GENERIC_GPIO dependence which should always
have been there for this driver.  Previously it was building a non working driver
as the stubs covered everything being used.  I'll sort a patch shortly and chase down
if we have any others missing GENERIC_GPIO dependencies.

Jonathan
> 
> drivers/staging/iio/resolver/ad2s1210.c:657:14: error: array type has incomplete element type
> drivers/staging/iio/resolver/ad2s1210.c:665:44: warning: type defaults to 'int' in type name
> drivers/staging/iio/resolver/ad2s1210.c:665:44: warning: type defaults to 'int' in type name
> drivers/staging/iio/resolver/ad2s1210.c:665:44: error: negative width in bit-field '<anonymous>'
> drivers/staging/iio/resolver/ad2s1210.c:671:14: error: array type has incomplete element type
> drivers/staging/iio/resolver/ad2s1210.c:679:34: warning: type defaults to 'int' in type name
> drivers/staging/iio/resolver/ad2s1210.c:679:34: warning: type defaults to 'int' in type name
> drivers/staging/iio/resolver/ad2s1210.c:679:34: error: negative width in bit-field '<anonymous>'

