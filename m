Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0F3Rga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:36:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab0F3Rg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 13:36:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 19:36:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       Andreas Dilger <adilger@dilger.ca>, viro@zeniv.linux.org.uk,
       smfrench@gmail.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <201006301531.39365.arnd@arndb.de> <20100630100553.707785c7@tlielax.poochiereds.net>
In-Reply-To: <20100630100553.707785c7@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301936.03804.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Oxr1RNM9hfN/QUsC5jlO0AYzbNdxxqKnoo4+
 9GGfQFr+EsK0Krs9H9DgPkRPbEzPdx+49/SMt5MJt7PJ8JLtS3
 +gcWpdrHTm1IjBMIoD82Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010, Jeff Layton wrote:
> In the event that we approach running out of flags, we could even use
> the last flag as a "HAS_FLAGS2" flag, to add a new flags field at the
> end. Ugly, but it would avoid the need for a new syscall. We can kick
> that potential problem down the road though. With 64 flags to play
> with, it likely won't be a problem for a while.

Along the lines of what Christoph argued, we can also just use the
new syscall when that happens.

	Arnd
