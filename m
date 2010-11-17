Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab0KQEp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:45:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35056 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab0KQEpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:45:24 -0500
MIME-Version: 1.0
Message-ID: <e5499ef1-c26d-4c9c-9336-5c61e65e45bc@default>
Date: Tue, 16 Nov 2010 20:44:42 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: linux-next: fate of the cleancache tree
References: <20101117133324.0654bfd9.sfr@canb.auug.org.au>
In-Reply-To: <20101117133324.0654bfd9.sfr@canb.auug.org.au>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> To: Linus; Dan Magenheimer
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Al Viro;
> Christoph Hellwig; Andrew Morton
> Subject: linux-next: fate of the cleancache tree
> 
> Hi Linus, Dan,
> 
> I didn't really follow the discussion at Kernel Summit, but there
> seemed
> to be some question as to whether the cleancache stuff will be merged
> or
> not.  It missed 2.6.37 (obviously), but my question now is do I keep in
> in linux-next in the hope that it will be merged in 2.6.38?  Or is that
> not going to happen?

Hi Stephen --

I am continuing to work towards other users for cleancache.  While
it is not clear if they will be ready in time for the 2.6.38 window,
it is possible.  If it is not too difficult to keep cleancache in
linux-next for now, I'd appreciate it if it stayed in.  However
if you or Linus prefer otherwise, I understand.

Thanks,
Dan
