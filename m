Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1CRSuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:50:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1CRSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:50:00 -0400
Date: Fri, 18 Mar 2011 14:49:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: pstore: fix leaking ->i_private
Message-ID: <20110318184957.GA6979@infradead.org>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
 <4d83a82032021e2997@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d83a82032021e2997@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another comment on pstore:

 - the kmsg_bytes attribute really should be a mount option.  no need
   have this in a completely different namespace, and require all the
   kobject mess around it.
