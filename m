Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2BBSjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:39:41 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36361 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932294Ab2BBSjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:39:40 -0500
X-Sasl-enc: 3WicSn3qgjWnZ9PxcpmWGu2dgQMvnIPXZh4yp12yZR8E 1328207979
Date: Thu, 2 Feb 2012 10:38:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        lenb@kernel.org, xen-devel@lists.xensource.com
Subject: Re: WARN... Device 'cpu1' does not have a release() function, it is
 broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
Message-ID: <20120202183851.GA28193@kroah.com>
References: <20120123180601.GA24553@phenom.dumpdata.com>
 <20120201222250.GA3854@kroah.com>
 <20120202174330.GA9311@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202174330.GA9311@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:43:30PM -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Feb 01, 2012 at 02:22:50PM -0800, Greg KH wrote:
> > Does the patch below solve the problem for you?
> 
> Hey Greg,
> 
> Indeed it does.
> 
> For the patch below, please put 'Tested-by: Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>'

Wonderful, thanks for testing, I'll queue this up soon.

greg k-h
