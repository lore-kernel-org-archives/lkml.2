Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161195Ab2JXVHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:07:14 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33264 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab2JXVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:07:12 -0400
X-Sasl-enc: L/lD88TlfpewRUnnwxdqcP30TNKHQfI3YrL8S3A/Wo6Y 1351112830
Date: Wed, 24 Oct 2012 14:07:09 -0700
From: Greg KH <greg@kroah.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable] xtensa: add missing system calls to the syscall
 table
Message-ID: <20121024210709.GA12308@kroah.com>
References: <5088517B.1010102@zankel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5088517B.1010102@zankel.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:37:15PM -0700, Chris Zankel wrote:
> Hi Greg,
> 
> Could you please include this patch in the next stable tree? It adds
> system calls required for libc builds, so would be great to have it
> there.

What stable releases do you want it in?

Also, please look at Documentation/stable_kernel_rules.txt for how to do
this properly (hint, emailing me isn't the best way...)

thanks,

greg k-h
