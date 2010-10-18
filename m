Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0JRRwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:52:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46215 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0JRRwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Aj/lOhEFAVFc5HqT8DIstKj0RFzGGJajxTmR6ioaeLF8mnsMxcD2RVOJsODWq6cGD5
         DUjnCiFm21NylpQtZ0xLagVuG1wntgnNJ0DXHQ524si+a2agSNujZ1vls+LQPpxdWGRG
         dN+ut+Opx9KakTMoDdPs0GlOZeif9b4zPFty0=
Subject: Re: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
 to prevent integer overflows.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: David Miller <davem@davemloft.net>, w@1wt.eu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
In-Reply-To: <20101018174339.GC14068@sgi.com>
References: <20101002112405.951704198@gulag1.americas.sgi.com>
	 <20101002112419.248437367@gulag1.americas.sgi.com>
	 <20101005.145032.25126909.davem@davemloft.net>
	 <20101018174339.GC14068@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 19:52:28 +0200
Message-ID: <1287424348.2359.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 18 octobre 2010 à 12:43 -0500, Robin Holt a écrit :
> On Tue, Oct 05, 2010 at 02:50:32PM -0700, David Miller wrote:
> > From: Robin Holt <holt@sgi.com>
> > Date: Sat, 02 Oct 2010 06:24:06 -0500
> > 
> > > Subject: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.
> > > 
> > > On a 16TB x86_64 machine, sysctl_tcp_mem[2], sysctl_udp_mem[2], and
> > > sysctl_sctp_mem[2] can integer overflow.  Set limit such that they are
> > > maximized without overflowing.
> > > 
> > > Signed-off-by: Robin Holt <holt@sgi.com>
> > 
> > Robin please resubmit this with the SCTP bits included.
> 
> David,
> 
> I did not mean to blow you off.  I was not going to resubmit because
> Eric's patch is the preferred direction.  I had been given an indication
> that my patch was preferred, but that indicator changed.
> 

Maybe there is some misunderstanding.

My patch was for net-next kernels (not before 2.6.37), while yours was
applicable to previous kernels.



