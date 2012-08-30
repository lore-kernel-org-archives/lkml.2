Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2H3VFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:05:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53200 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2H3VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:05:23 -0400
Date: Thu, 30 Aug 2012 14:05:19 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 01/11] vmci_context.patch: VMCI context list operations.
Message-ID: <20120830210519.GC3276@kroah.com>
References: <20120824171042.4775.36871.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20120824171551.4775.87175.stgit@promb-2n-dhcp175.eng.vmware.com>
 <15333E71B3DDCB48A90165AD57993F285685DB43D7@exch-mbx-114.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15333E71B3DDCB48A90165AD57993F285685DB43D7@exch-mbx-114.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:38:08AM -0700, George Zhang wrote:
> 
> 
> Signed-off-by: George Zhang <georgezhang@vmware.com>

You seem to have forgotten to provide a valid changelog comment for this
patch, and all others in this series.  Remember, your 00/11 email will
not be applied to the system, so the info needs to be in the patches
themselves.

greg k-h
