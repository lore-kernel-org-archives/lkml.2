Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0HZLsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:48:05 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35810 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0HZLsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:48:00 -0400
Message-Id: <20100826114122.292120483@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 13:41:22 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, mmarek@suse.cz, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, brueckner@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com
In-Reply-To: <20100825180601.GA2116@merkur.ravnborg.org>
Subject: [PATCH v2 0/2] initramfs: Cleanup and fix initramfs size calculation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 08:06:01PM +0200, Sam Ravnborg wrote:
> On Wed, Aug 25, 2010 at 05:57:12PM +0200, Michael Holzheu wrote:
>
> > The patch also restructures the "usr/initramfs_data.xxx.S" files to use a
> > common macro that includes the (compressed) initramfs file and calculates
> > the __initramfs_size.
> I like this anyway. Could you do this as a separate patch?

Done ;-)

The first patch in this series introduces a common initramfs_data.S file
that is shared by the compression variants.  The second patch adds the new
initramfs size calculation proposed in the initial patch.
See the patch description for more details.


Kind regards,
  Hendrik
