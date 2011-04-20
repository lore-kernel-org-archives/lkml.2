Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1DTUlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:41:51 -0400
Received: from kroah.org ([198.145.64.141]:40296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab1DTUld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:41:33 -0400
Date: Wed, 20 Apr 2011 13:40:58 -0700
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] hv: remove double newline in DPRINT functions
Message-ID: <20110420204058.GA17319@kroah.com>
References: <20110416165038.986214764@aepfle.de>
 <20110416165054.165322229@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416165054.165322229@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 06:50:43PM +0200, Olaf Hering wrote:
> Remove double newline in DPRINT* functions, the macro already adds a  newline.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

This one no longer applies :(

thanks,

greg k-h
