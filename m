Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0LJSKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:10:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0LJSKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:10:34 -0500
Date: Fri, 10 Dec 2010 10:04:00 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] staging: ft1000: Convert char device to debugfs.
Message-ID: <20101210180400.GB12085@suse.de>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
 <1291890413-15255-2-git-send-email-marek.belisko@open-nandra.com>
 <20101209104336.GT10623@bicker>
 <20101210173533.GB2505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210173533.GB2505@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 12:35:33PM -0500, Dave Jones wrote:
> On Thu, Dec 09, 2010 at 01:43:36PM +0300, Dan Carpenter wrote:
>  > > +	file = debugfs_create_file("device", S_IRUGO | S_IWUGO, dir,
>  >                                                        ^^^^^^^
>  > > +					NULL, &ft1000fops);
>  > 
>  > Don't make this world writeable.
> 
> we should probably make checkpatch catch this.
> 
> 
> 
> 
> Exporting world writable sysfs/debugfs files is usually a bad thing.
> Warn about it.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

