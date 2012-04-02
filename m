Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2DBXmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:42:52 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54790 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2DBXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:42:51 -0400
Date: Mon, 2 Apr 2012 16:42:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Carlos Chinea <carlos.chinea@nokia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HSI: Add HSI API documentation
Message-ID: <20120402234241.GB18183@kroah.com>
References: <20120402165607.3C0457C006E@ra.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402165607.3C0457C006E@ra.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 04:56:07PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=a4ac73a701288f633fbf2369ffaae4841aa295b3
> Commit:     a4ac73a701288f633fbf2369ffaae4841aa295b3
> Parent:     f9e402016de91c2444e46ecfd706880969b1ae9e
> Author:     Carlos Chinea <carlos.chinea@nokia.com>
> AuthorDate: Thu Apr 29 13:19:06 2010 +0300
> Committer:  Carlos Chinea <carlos.chinea@nokia.com>
> CommitDate: Thu Jan 5 15:42:13 2012 +0200
> 
>     HSI: Add HSI API documentation
>     
>     Add an entry for HSI in the device-drivers section of
>     the kernel documentation.
>     
>     Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  Documentation/DocBook/device-drivers.tmpl |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)

Where is your Documentation/ABI/ files as well?  You created sysfs
files, you have to document them.

greg k-h
