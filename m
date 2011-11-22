Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab1KVUfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:35:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35871 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1KVUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:35:40 -0500
Subject: Re: [PATCH] nfsd: Fix oops when parsing a 0 length export
From: Sasha Levin <levinsasha928@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org
In-Reply-To: <20111122202817.GD21451@fieldses.org>
References: <1321611289-21809-1-git-send-email-levinsasha928@gmail.com>
	 <20111122202817.GD21451@fieldses.org>
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 22 Nov 2011 22:33:29 +0200
Message-ID: <1321994009.3787.19.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 15:28 -0500, J. Bruce Fields wrote:
> On Fri, Nov 18, 2011 at 12:14:49PM +0200, Sasha Levin wrote:
> > expkey_parse() oopses when handling a 0 length export. This is easily
> > triggerable from usermode by writing 0 bytes into
> > '/proc/[proc id]/net/rpc/nfsd.fh/channel'.
> 
> Thanks--how did you run across this?
> 
> --b.

Tried running a fuzzer on the system.

-- 

Sasha.

