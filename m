Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0FTJXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 05:23:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab0FTJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 05:23:40 -0400
Date: Sun, 20 Jun 2010 11:23:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec: export kexec.h to userspace
Message-ID: <20100620092333.GA10987@basil.fritz.box>
References: <20100619132235.GA24200@basil.fritz.box>
 <20100619182419.GA22079@merkur.ravnborg.org>
 <20100619195345.GT18946@basil.fritz.box>
 <20100620082315.GA23188@merkur.ravnborg.org>
 <m1bpb6ozef.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpb6ozef.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we please do this the other way around and create a kexec_user.h?
> Having a an xxx_user.h is a pattern we already have in the kernel.
> I can't find a signle xxxx_kernel.h

If you do that you have to change the man page.

Or just keep my simple patch.

-Andi
