Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0HZIqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:46:47 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:56072 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0HZIqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:46:45 -0400
Subject: Re: [PATCH] Fix initramfs size calculation
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: sam@ravnborg.org, tabbott@ksplice.com, vda.linux@googlemail.com,
        mmarek@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com
In-Reply-To: <4C7578A6.2080303@linux.intel.com>
References: <1282751832.3676.17.camel@holzheu-laptop>
	 <4C7578A6.2080303@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 26 Aug 2010 10:46:36 +0200
Message-ID: <1282812396.1879.7.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Wed, 2010-08-25 at 13:10 -0700, H. Peter Anvin wrote:
> On 08/25/2010 08:57 AM, Michael Holzheu wrote:
> > Certain s390 instructions, especially instructions for loading addresses
> > (larl) or branch addresses must be on even addresses. 
> 
> I have to admit to finding this fairly disturbing, as this is likely to
> come up again and again.  Is there any way to tell gcc (e.g. with an
> alignment attribute) that a particular symbol is not safe to be loaded
> with larl?

I think, it is not possible the change that in the compiler. The fact
that the compiler on s390 assumes that symbols are 2 byte aligned was a
design decission and is part of the ABI.

Michael 

