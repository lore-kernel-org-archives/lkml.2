Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2J3FVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:21:54 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:55515 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab2J3FVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:21:53 -0400
Date: Mon, 29 Oct 2012 22:21:52 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 08/12] VMCI: resource object implementation.
Message-ID: <20121030052152.GG32055@dtor-ws.eng.vmware.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010453.17788.90295.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030022946.GI1920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030022946.GI1920@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:29:46PM -0700, Greg KH wrote:
> On Mon, Oct 29, 2012 at 06:04:58PM -0700, George Zhang wrote:
> > VMCI resource tracks all used resources within the vmci code.
> 
> Same "kref_put() with no lock seen" question in this file, prove me
> wrong please.

Same proof as with others, the reference can't be taken unless the
resource is in hast table (which protected by RCU/spinlock) so no fear
of bouncing off 0.

Thanks,
Dmitry

