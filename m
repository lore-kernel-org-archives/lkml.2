Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2APSVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:21:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab2APSU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:20:58 -0500
Date: Mon, 16 Jan 2012 10:19:40 -0800
From: Greg KH <gregkh@suse.de>
To: jhbird.choi@samsung.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: Fix null reference in
 subsys_interface_unregister
Message-ID: <20120116181940.GD23628@suse.de>
References: <1326506763-9821-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326506763-9821-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 11:06:03AM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Check if the sif is not NULL before de-referencing it

Why would it be?  Have you hit this somehow?  If so, in what code?

thanks,

greg k-h
