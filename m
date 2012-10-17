Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2JQX5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:57:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17658 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2JQX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:57:29 -0400
Date: Wed, 17 Oct 2012 16:57:18 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@citrix.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH 6/6] xen: x86 pvh: use XENMEM_add_to_physmap_range for
 foreign gmfn mappings
Message-ID: <20121017165718.683fa30f@mantra.us.oracle.com>
In-Reply-To: <1350473532-15863-6-git-send-email-ian.campbell@citrix.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
	<1350473532-15863-6-git-send-email-ian.campbell@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012 12:32:12 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> Squeezing the necessary fields into the existing XENMEM_add_to_physmap
> interface was proving to be a bit tricky so we have decided to go with
> a new interface upstream (the XENMAPSPACE_gmfn_foreign interface using
> XENMEM_add_to_physmap was never committed anywhere). This interface
> also allows for batching which was impossible to support at the same
> time as foreign mfns in the old interface.
> 
> This reverts the relevant parts of "PVH: basic and header changes,
> elfnote changes, ..." and followups and trivially converts
> pvh_add_to_xen_p2m over.


Hmm... I don't see xen side implementation of XENMEM_add_to_physmap_range,
and since I've already got my patches tested and cut, I'm going to send
them now. We can apply this change easily in konrad's tree.

thanks,
mukesh

