Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2EIHIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:08:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35792 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2EIHIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:08:09 -0400
Date: Wed, 9 May 2012 02:07:59 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>,
        Orion Poplawski <orion@cora.nwra.com>
Subject: Re: [ 061/167] [PATCH] nfsd: dont fail unchecked creates of
 non-special files
Message-ID: <20120509070758.GC32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055038.318026845@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055038.318026845@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> 3.2-stable review patch.
[...]
> commit 9dc4e6c4d1182d34604ea40fef641775f5b15456 upstream.
[...]
> [bwh: Backported to 3.2: use &resfh, not resfh]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Looks good.  Greg, I think this backport can be reused for 3.3.y,
where the upstream patch similarly does not apply for lack of
v3.4-rc1~40^2~19 ("nfsd4: reduce do_open_lookup() stack usage").

Thanks,
Jonathan
