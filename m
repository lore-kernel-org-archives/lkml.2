Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2JQInD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:43:03 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57955 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2JQIm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:42:59 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <18137.1349203013@warthog.procyon.org.uk>
References: <18137.1349203013@warthog.procyon.org.uk>
Date: Wed, 17 Oct 2012 09:42:57 +0100
Message-ID: <CAAG0J9_gYLn5+4j9WUnPmxWyJfQK_b8e5xjxZdRPG21euXoCFg@mail.gmail.com>
Subject: Re: [GIT PULL] User API Disintegrate: Preparatory patches
From: James Hogan <james@albanarts.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, arnd@arndb.de, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
        fengguang.wu@intel.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2012 19:36, David Howells <dhowells@redhat.com> wrote:
> The patches herein prepare for the extraction of the Userspace API bits from
> the various header files named in the Kbuild files.
>
> [IMPORTANT NOTE!  These patches may need regenerating if the header files
>  change too much.  This doesn't normally take very long to do as the
>  disintegration procedure is almost entirely scripted.]

Hi David,

Any chance you (or somebody else) can point me towards your latest
scripts for all this UAPI disintegration work? They don't seem to be
in the kernel tree, and the only scripts I can find are from 2011 so I
guess they're probably a bit out of date.

Thanks in advance
-- 
James Hogan
