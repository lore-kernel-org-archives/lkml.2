Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab2JYQHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:07:46 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57183 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966Ab2JYQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:07:44 -0400
Date: Thu, 25 Oct 2012 09:07:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Message-ID: <20121025160741.GB4341@kroah.com>
References: <1351174667-5098-1-git-send-email-bp@amd64.org>
 <1351174667-5098-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351174667-5098-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 04:17:43PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@alien8.de>
> 
> ... which, analogous to DEVICE_INT_ATTR provides functionality to
> set/clear bools. Its purpose is to be used where values need to be used
> as booleans in configuration context.
> 
> Next patch uses this.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Borislav Petkov <bp@alien8.de>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Do you want me to take this through my tree now?  If not, I have no
objection to it being part of this larger series and go to Linus through
whatever tree takes it.

thanks,

greg k-h
