Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0GVT5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:57:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24965 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0GVT5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:57:12 -0400
MIME-Version: 1.0
Message-ID: <a9978c9a-6d85-477e-9962-395208fb5dd4@default>
Date: Thu, 22 Jul 2010 12:54:57 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <greg@kroah.com>, Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8] zcache: page cache compression support
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org
 20100722191457.GA13309@kroah.com>
In-Reply-To: <20100722191457.GA13309@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C48A25B.0071:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, July 22, 2010 1:15 PM
> To: Nitin Gupta
> Cc: Pekka Enberg; Hugh Dickins; Andrew Morton; Dan Magenheimer; Rik van
> Riel; Avi Kivity; Christoph Hellwig; Minchan Kim; Konrad Rzeszutek
> Wilk; linux-mm; linux-kernel
> Subject: Re: [PATCH 0/8] zcache: page cache compression support
> 
> On Fri, Jul 16, 2010 at 06:07:42PM +0530, Nitin Gupta wrote:
> > Frequently accessed filesystem data is stored in memory to reduce
> access to
> > (much) slower backing disks. Under memory pressure, these pages are
> freed and
> > when needed again, they have to be read from disks again. When
> combined working
> > set of all running application exceeds amount of physical RAM, we get
> extereme
> > slowdown as reading a page from disk can take time in order of
> milliseconds.
> 
> <snip>
> 
> Given that there were a lot of comments and changes for this series,
> can
> you resend them with your updates so I can then apply them if they are
> acceptable to everyone?
> 
> thanks,
> greg k-h

Hi Greg --

Nitin's zcache code is dependent on the cleancache series:
http://lkml.org/lkml/2010/6/21/411 

The cleancache series has not changed since V3 (other than
fixing a couple of documentation typos) and didn't receive any
comments other than Christoph's concern that there weren't
any users... which I think has been since addressed with the
posting of the Xen tmem driver code and Nitin's zcache.

If you are ready to apply the cleancache series, great!
If not, please let me know next steps so cleancache isn't
an impediment for applying the zcache series.

Thanks,
Dan
