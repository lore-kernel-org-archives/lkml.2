Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0HPNE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:04:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:51761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab0HPNE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:04:28 -0400
Date: Mon, 16 Aug 2010 15:04:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] paravirt: noreplace-paravirt is implemented for x86 and
 ia-64
In-Reply-To: <4C62D309.5010909@goop.org>
Message-ID: <alpine.LNX.2.00.1008161503550.1019@pobox.suse.cz>
References: <alpine.LNX.2.00.1008111832510.2702@pobox.suse.cz> <4C62D309.5010909@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010, Jeremy Fitzhardinge wrote:

>  On 08/11/2010 09:34 AM, Jiri Kosina wrote:
> > kernel-parameters.txt lists 'noreplace-paravirt' parameter as being
> > limited to X86-32, which is incorrect -- it's actually supported by
> > x86-32, x86-64 and ia-64.
> > 
> > Signed-off-by: Jiri Kosina<jkosina@suse.cz>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Thanks. As I haven't found the patch in linux-next as of today, I'll be 
taking it through trivial queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
