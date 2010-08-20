Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab0HTJxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:53:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:46863 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0HTJxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:53:18 -0400
Date: Fri, 20 Aug 2010 19:53:03 +1000
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        npiggin@suse.de, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100820195303.20b17210@notabene>
In-Reply-To: <20100820083057.GA10039@infradead.org>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100820083057.GA10039@infradead.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 04:30:57 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> Suddenly getting an file pointer for a symlink which could never happen
> before is a really bad idea.  Just add a proper readlink_by_handle
> system call, similar to what's done in the XFS interface.

Why is that?
With futexes we suddenly get a file descriptor for something we could never
get a file descriptor on before and that doesn't seem to be a problem.

Why should symlinks be special as the only thing that you cannot have a file
descriptor for?  Uniformity of interface is a very valuable property.

NeilBrown
