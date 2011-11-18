Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1KRB7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 20:59:47 -0500
Received: from iamlegend.mr.itd.umich.edu ([141.211.14.68]:54685 "EHLO
	iamlegend.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab1KRB7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 20:59:45 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Nov 2011 20:59:45 EST
Date: Thu, 17 Nov 2011 20:51:16 -0500
From: Jim Rees <rees@umich.edu>
To: Jeff Layton <jlayton@redhat.com>
Cc: John Hughes <john@Calva.COM>, Trond Myklebust <trond.myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't hang user processes if Kerberos ticket for nfs4
 mount expires
Message-ID: <20111118015116.GA1959@umich.edu>
References: <4EC3FD8B.6000705@calvaedi.com>
 <20111116144718.78b2e288@corrin.poochiereds.net>
 <20111116234434.GA12882@umich.edu>
 <20111116203119.1d9c0dd6@corrin.poochiereds.net>
 <20111116203810.4e1b9d28@corrin.poochiereds.net>
 <4EC4EA91.5070607@Calva.COM>
 <4EC50882.2080803@Calva.COM>
 <20111117164630.394027e7@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117164630.394027e7@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would argue that if you don't want your applications to stop working when
your ticket expires, you shouldn't let the ticket expire.  If you don't want
to have to renew your ticket, you should use an infinite ticket lifetime.

It sounds like you've made up your mind, but I would urge you to make this
a mount option, analogous to the hard/soft mount option.
