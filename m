Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab1DZACv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:02:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531Ab1DZACs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:02:48 -0400
Date: Mon, 25 Apr 2011 17:00:24 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Foley <pefoley2@verizon.net>
Cc: linux-kernel@vger.kernel.org, hjanssen@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH] staging: hv: make HYPERV_UTILS depend on NLS to prevent
 a build error
Message-ID: <20110426000024.GB11787@suse.de>
References: <4DB60932.6090000@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB60932.6090000@verizon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 07:52:18PM -0400, Peter Foley wrote:
> This patch adds a dependency on NLS to HYPERV_UTILS to avoid a build error.

What is the build error?

thanks,

greg k-h
