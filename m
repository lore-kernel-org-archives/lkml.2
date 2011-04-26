Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab1DZUch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:32:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41405 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1DZUcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:32:36 -0400
Subject: Re: [PATCH 1/3] flex_array: flex_array_prealloc takes a number of
 elements, not an end
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: steffen.klassert@secunet.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
In-Reply-To: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 26 Apr 2011 13:32:21 -0700
Message-ID: <1303849941.9308.17353.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 21:45 -0400, Eric Paris wrote:
> Change flex_array_prealloc to take the number of elements for which space
> should be allocated instead of the last (inclusive) element. Users
> and documentation are updated accordingly.
> 
> Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Perhaps add this to the description?

flex_arrays got introduced before they had users.  When folks started
using it, they ended up needing a different API than we coded up
originally.  This swaps over to the API that folks apparently need.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

