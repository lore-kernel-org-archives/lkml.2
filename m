Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0J0WmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:42:00 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34489 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab0J0Wl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:41:59 -0400
Date: Wed, 27 Oct 2010 15:41:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] namespace: add source file location exceptions
Message-ID: <20101027154153.02b0607e@nehalam>
In-Reply-To: <4CC8A836.9090402@suse.cz>
References: <20101013155830.169ca022@nehalam>
	<4CC8A836.9090402@suse.cz>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 00:31:18 +0200
Michal Marek <mmarek@suse.cz> wrote:

> On 14.10.2010 00:58, Stephen Hemminger wrote:
> > Teach namespace checker about some special case files where the
> > source is in unusual location.  This fixes many of the source file
> > not found errors (more can be added), and also prevents false positives
> > for functions not being used.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> > ---
> > Applies after previous patches by Amerigo Wang
> 
> Applied to kbuild-2.6.git#misc, sorry for the delay.
> 
> Michal

That patch should not be included. It causes more problems than it
solves, since then there are duplicate file locations which causes
false duplicate symbol reports.

-- 
