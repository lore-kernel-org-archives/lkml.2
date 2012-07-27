Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab2G0KAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:00:41 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:50980 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2G0KAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:00:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13731251"
Message-ID: <1343383205.6812.137.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [RFC PATCH] Boot PV guests with more than 128GB
 (v1) for 3.7
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
Date: Fri, 27 Jul 2012 11:00:05 +0100
In-Reply-To: <501260980200007800090E08@nat28.tlf.novell.com>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
	 <501260980200007800090E08@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 08:34 +0100, Jan Beulich wrote:
> >>> On 26.07.12 at 22:47, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >  2). Allocate a new array, copy the existing P2M into it,
> >     revector the P2M tree to use that, and return the old
> >     P2M to the memory allocate. This has the advantage that
> >     it sets the stage for using XEN_ELF_NOTE_INIT_P2M
> >     feature. That feature allows us to set the exact virtual
> >     address space we want for the P2M - and allows us to
> >     boot as initial domain on large machines.
> 
> And I would hope that the tools would get updated to recognize
> this note too, so that huge DomU-s would become possible as
> well.

Does this help us with >160GB 32 bit PV guests too? I'm guessing not
since the real limitation there is the relatively small amount of kernel
address space.

