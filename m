Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1DZTGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab1DZTGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:06:43 -0400
Subject: Re: [PATCH 1/3] flex_array: flex_array_prealloc takes a number of
 elements, not an end
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave@linux.vnet.ibm.com, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Date: Tue, 26 Apr 2011 15:06:27 -0400
In-Reply-To: <20110426115638.379068b1.akpm@linux-foundation.org>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
	 <20110426115638.379068b1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1303844791.2101.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 11:56 -0700, Andrew Morton wrote:
> On Mon, 25 Apr 2011 21:45:31 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> > Change flex_array_prealloc to take the number of elements for which space
> > should be allocated instead of the last (inclusive) element. Users
> > and documentation are updated accordingly.
> 
> Why?

All three of these patches came from these discussions:
http://marc.info/?t=129552800100005&r=1&w=2
http://marc.info/?t=129646395700004&r=1&w=2
http://marc.info/?t=129708178200007&r=1&w=2

1/3 was changed just because it seemed to be the way the interface was
used

2/3 was changed because the 2.6.38 kernel fails to load certain selinux
policies which worked under 2.6.37 because of this lack of functionality

3/3 was changed just because that's how maybe it should work, although
there are no known users.

I can certainly update 2/3 to better explain the rational but I can't
really do any better on 1/3 and 3/3 other than to just say what the
change is......

-Eric

