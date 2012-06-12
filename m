Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2FLXQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 19:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2FLXQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 19:16:13 -0400
Date: Tue, 12 Jun 2012 19:16:01 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: mount.nfs: cannot allocate memory
Message-ID: <20120612231601.GA30715@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Lord <kernel@teksavvy.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>
References: <4FD7C65F.80602@teksavvy.com>
 <4FD7C7C6.9030204@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD7C7C6.9030204@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 06:50:46PM -0400, Mark Lord wrote:

 > Looks like an old bug, perhaps:
 > https://bugzilla.redhat.com/show_bug.cgi?id=593035
 > https://bugzilla.redhat.com/show_bug.cgi?id=728003
 > 
 > I wonder what the underlying cause is?
 > And I also wonder if the NFS code should be more clever
 > about handing order-4 allocation failures.

>From memory, I don't think we've seen new reports of this since we switched to (now dead)
CONFIG_NFS_USE_NEW_IDMAPPER=y.

	Dave


