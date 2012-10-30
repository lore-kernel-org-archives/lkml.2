Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2J3CSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:18:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48955 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab2J3CSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:18:44 -0400
Date: Mon, 29 Oct 2012 19:19:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 00/12] VMCI for Linux upstreaming
Message-ID: <20121030021938.GC1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:03:28PM -0700, George Zhang wrote:
>  drivers/misc/Kconfig                      |    1
>  drivers/misc/Makefile                     |    2
>  drivers/misc/vmw_vmci/Kconfig             |   16
>  drivers/misc/vmw_vmci/Makefile            |   43

Meta comment here, why drivers/misc/?  The other hypervisor
infrastructures all have their own directory under drivers/  Should we
be moving everything to drivers/hyperv/ somehow?

thanks,

greg k-h
