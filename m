Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2HQQv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:51:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54638 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab2HQQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:51:20 -0400
Date: Fri, 17 Aug 2012 09:51:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
Message-ID: <20120817165109.GA11323@kroah.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345167145-5513-8-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> Now, gather DNS information. Invoke an external script (that can be
> distro dependent) to gather the DNS information.

Where is that script?  Why a script, this really isn't in a standard
method for all Linux distros?  If not, why not work to do that like the
freedesktop.org people have done for other system configuration items?

greg k-h
