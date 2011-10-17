Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab1JQPWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1JQPWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:22:32 -0400
Date: Mon, 17 Oct 2011 08:21:49 -0700
From: Greg KH <gregkh@suse.de>
To: Conny Seidel <conny.seidel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [00/38] 3.0.7-stable review
Message-ID: <20111017152149.GA10897@suse.de>
References: <20111011165903.GA30976@kroah.com>
 <20111011170026.GB31075@kroah.com>
 <20111017170503.7bd4bce8.conny.seidel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017170503.7bd4bce8.conny.seidel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 05:05:03PM +0200, Conny Seidel wrote:
> Hi,
> 
> is there a reason why the v3.0.7 tag is missing from the stable
> repository?
> 
> 
> [/build/linux-stable]$ make kernelrelease
> 3.0.7+
> [/build/linux-stable]$ make kernelversion
> 3.0.7
> [/build/linux-stable]$ git describe
> v3.0.6-33-g62bf792

Yes, it's not "officially" released yet, I'm still doing testing...

greg k-h
