Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2HOQay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:30:54 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37056 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192Ab2HOQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:30:52 -0400
X-Sasl-enc: 8sGZsZXSiWxZ7Lr9er3f9rOc6A2WoZhHXDyadc0QcDCt 1345048251
Date: Wed, 15 Aug 2012 13:30:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [ 36/44] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120815163046.GA30736@khazad-dum.debian.net>
References: <20120813220142.113186818@linuxfoundation.org>
 <20120813220145.337264645@linuxfoundation.org>
 <20120815002654.GA11666@khazad-dum.debian.net>
 <20120815140655.GC22871@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815140655.GC22871@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Greg Kroah-Hartman wrote:
> On Tue, Aug 14, 2012 at 09:26:54PM -0300, Henrique de Moraes Holschuh wrote:
> > I believe the patch bellow, which was required on 3.2, will also be
> > necessary.
> 
> Will it be necessary to apply this before this patch goes in the series,
> or after it?

Applying after fixes a build error.  Applying before might avoid the build
error altogether (error happens when #undef CONFIG_SMP), AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
