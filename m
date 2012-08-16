Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab2HPTfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:35:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65405 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2HPTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:35:41 -0400
Date: Thu, 16 Aug 2012 12:35:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com,
        jagrelo@cisco.com
Subject: Re: [PATCH 1/1] Drivers: hv: Explicitly size elements of protocol
 structures
Message-ID: <20120816193537.GA14719@kroah.com>
References: <1345130600-2862-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345130600-2862-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 08:23:20AM -0700, K. Y. Srinivasan wrote:
> Use explicitly sized types in data structures defining the host/guest
> protocol. I would like to thank Juan Sanchez-Agrelo  <jagrelo@cisco.com> 
> for reporting this.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

If someone reports a problem, mark it as:
	Reported-by: Juan Sanchez-Agrelo <jagrelo@cisco.com>
in the signed-off-by: area of the patch.

Does this need to go into 3.6, and possibly older kernels?  Or can it
wait for 3.7?

thanks,

greg k-h
