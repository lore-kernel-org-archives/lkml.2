Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1KRRyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:54:15 -0500
Received: from smtp.mail.umich.edu ([141.211.14.81]:60502 "EHLO
	hackers.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1KRRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:54:14 -0500
Date: Fri, 18 Nov 2011 12:54:09 -0500
From: Jim Rees <rees@umich.edu>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: John Hughes <john@Calva.COM>, Jeff Layton <jlayton@redhat.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't hang user processes if Kerberos ticket for nfs4
 mount expires
Message-ID: <20111118175409.GA1347@umich.edu>
References: <00c101cca615$c2e08db6$78be630a@hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c101cca615$c2e08db6$78be630a@hq.netapp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Myklebust, Trond wrote:

  So what are they supposed to do without tickets? Crash?

No, why would they want to do that?

I feel like I've entered the Twilight Zone here, so please continue without
me while I dig up the relevant background info.
