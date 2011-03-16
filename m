Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1CPLsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:48:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54038 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1CPLsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:48:12 -0400
Date: Wed, 16 Mar 2011 11:47:52 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl: never finishes w/ specific file
Message-ID: <20110316114752.GI1407@shadowen.org>
References: <201103021731.01598.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103021731.01598.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:31:01PM +0100, Toralf Förster wrote:
> Hello,
> 
> this runs infinitely :
> 
> ./scripts/checkpatch.pl --file ./drivers/staging/rtl8192u/r819xU_firmware_img.c
> 
> Is this a known behaviour of checkpatch.pl  ?

That one may be already fixed in my development version.  The form of
the file is familiar.

Could you try your file with the one below and let me know:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
