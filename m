Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695Ab0GPGy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 02:54:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48474 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935636Ab0GPGy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 02:54:28 -0400
Date: Fri, 16 Jul 2010 15:54:24 +0900
From: Simon Horman <horms@verge.net.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec: export kexec.h to userspace
Message-ID: <20100716065424.GA20761@verge.net.au>
References: <20100619132235.GA24200@basil.fritz.box>
 <20100619182419.GA22079@merkur.ravnborg.org>
 <20100619195345.GT18946@basil.fritz.box>
 <20100620082315.GA23188@merkur.ravnborg.org>
 <m1bpb6ozef.fsf@fess.ebiederm.org>
 <20100620092333.GA10987@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620092333.GA10987@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 11:23:34AM +0200, Andi Kleen wrote:
> > Can we please do this the other way around and create a kexec_user.h?
> > Having a an xxx_user.h is a pattern we already have in the kernel.
> > I can't find a signle xxxx_kernel.h
> 
> If you do that you have to change the man page.
> 
> Or just keep my simple patch.

It seems more logical to me to update the documentation -
its new documentation, isn't it?

