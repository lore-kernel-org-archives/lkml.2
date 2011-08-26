Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1HZSe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:34:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33484 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab1HZSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:34:56 -0400
X-Sasl-enc: kA/bCdbVFL62VNFRhCjfG8lBBeEZlm/MjtkCmtWoNirK 1314383695
Date: Fri, 26 Aug 2011 11:29:00 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dynamic debug: cleanups + compile fix
Message-ID: <20110826182900.GA30226@kroah.com>
References: <cover.1314291909.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1314291909.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:34:06PM -0400, Jason Baron wrote:
> Hi,
> 
> This is a re-post of the last 3 patches, as requested by Greg:
> https://lkml.org/lkml/2011/8/11/378
> 
> I've also added a compile fix that Randy Dunlap found in the -next tree.

Care to redo this based on the comments received so far?

thanks,

greg k-h
