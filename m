Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2GZAHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:07:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:45735 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab2GZAHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173243727"
Date: Thu, 26 Jul 2012 01:25:02 +0100
From: Alan Cox <alan@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120726012502.571205f4@bob.linux.org.uk>
In-Reply-To: <20120726085127.1205fa271d6c5d7c485c5397@canb.auug.org.au>
References: <20120720133349.b71eeca40aa1758a12725dea@canb.auug.org.au>
	<20120726085127.1205fa271d6c5d7c485c5397@canb.auug.org.au>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012 08:51:27 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg, Alan,
> 
> [Sorry, Alan, I forgot to cc you the first time around.]
> 
> On Fri, 20 Jul 2012 13:33:49 +1000 Stephen Rothwell
> <sfr@canb.auug.org.au> wrote:
> >
> > After merging the tty tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/staging/serqt_usb2/serqt_usb2.c: In function
> > 'qt_set_termios': drivers/staging/serqt_usb2/serqt_usb2.c:1198:29:
> > error: incompatible types when initializing type 'struct ktermios
> > *' using type 'struct ktermios'
> > drivers/staging/serqt_usb2/serqt_usb2.c:1304:14: error: invalid
> > type argument of '->' (have 'struct ktermios')
> > 

I sent you a fix for that one (I've not done the ipoctal one yet)

Alan
