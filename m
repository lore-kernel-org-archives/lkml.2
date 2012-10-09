Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2JISoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:44:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17643 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2JISn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:43:58 -0400
Date: Tue, 9 Oct 2012 14:32:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for xen
Message-ID: <20121009183206.GA26104@phenom.dumpdata.com>
References: <30773.1349789452@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30773.1349789452@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:30:52PM +0100, David Howells wrote:
> Can you merge the following branch into the xen tree please.

What is up with your key?

UAPI Disintegration 2012-10-09
# gpg: Signature made Tue 09 Oct 2012 04:54:52 AM EDT using RSA key ID 044B2B3B
# gpg: requesting key 044B2B3B from hkp server pgp.mit.edu
# gpg: no valid OpenPGP data found.
# gpg: Total number processed: 0
# gpg: Can't check signature: public key not found

> 
> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches, userspace
> headers will be segregated into:
> 
> 	include/uapi/linux/.../foo.h
> 
> for the userspace interface stuff, and:
> 
> 	include/linux/.../foo.h
> 
> for the strictly kernel internal stuff.
> 
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-xen-20121009
> 
> for you to fetch changes up to 72503791edffe516848d0f01d377fa9cd0711970:
> 
>   UAPI: (Scripted) Disintegrate include/xen (2012-10-09 09:49:15 +0100)
> 
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
> 
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate include/xen
> 
>  include/uapi/xen/Kbuild          | 2 ++
>  include/{ => uapi}/xen/evtchn.h  | 0
>  include/{ => uapi}/xen/privcmd.h | 0
>  include/xen/Kbuild               | 2 --
>  4 files changed, 2 insertions(+), 2 deletions(-)
>  rename include/{ => uapi}/xen/evtchn.h (100%)
>  rename include/{ => uapi}/xen/privcmd.h (100%)
> .
