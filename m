Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2JKMtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:49:11 -0400
Received: from mga07.intel.com ([143.182.124.22]:48232 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756712Ab2JKMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:49:07 -0400
Message-ID: <1349959738.15966.512.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 0/5] efivarfs: fixes and cleanups
From: Matt Fleming <matt.fleming@intel.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 13:48:58 +0100
In-Reply-To: <1349951541-20498-1-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 11:32 +0100, Andy Whitcroft wrote:
> We have recently been looking to backport the efivarfs support as posted,
> to 3.5.x.  Inspired by some searching questions from Tetsuo Handa I have
> been reviewing this code.  The following a first pass at fixing up some
> of the error handling.  As they represent error paths they are hard to
> truly verify so deserve review.
> 
> On top of 7b218e8e5d433fc8b531ce911926e06de3e6f1f6 in Matt Flemmings efi.git
> repo.
> 
> -apw
> 
> Andy Whitcroft (5):
>   efivarfs: efivarfs_file_read ensure we free data in error paths
>   efivarfs: efivarfs_create() ensure we drop our reference on inode on error
>   efivarfs: efivarfs_fill_super() fix inode reference counts
>   efivarfs: efivarfs_fill_super() ensure we free our temporary name
>   efivarfs: efivarfs_fill_super() ensure we clean up correctly on error
> 
>  drivers/firmware/efivars.c |   56 +++++++++++++++++++++++++++-----------------
>  1 file changed, 35 insertions(+), 21 deletions(-)

Thanks Andy, I've added Matthew's Acked-by and applied this series to my
'next' branch.

