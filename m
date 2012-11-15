Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2KOXtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:49:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45578 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KOXs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:48:59 -0500
Date: Thu, 15 Nov 2012 15:48:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 07/12] VMCI: queue pairs implementation.
Message-ID: <20121115234855.GA8369@kroah.com>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121107184210.9658.57625.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107184210.9658.57625.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 10:42:15AM -0800, George Zhang wrote:
> VMCI queue pairs allow for bi-directional ordered communication between host and guests.

You obviously didn't run checkpatch on this file :(

Please send me a follow-on patch to resolve the issues it found, before
someone else does...

thanks,

greg k-h
