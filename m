Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1FKGC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 02:02:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50196 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1FKGC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 02:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pKiHnMGQs3IILfgJ3xwsRW7+L8u8A8eArzbBUYn3gK9viGjueK435kWEfmEFIKYaAZ
         QR1rcGrg2pI4nA2peB6WGwhViFWbvAuTxe5b+2iLNQxFEWFQIB7ItKQ5pf59aHTyX4/l
         WnNIr5PICMR2HhY+Siu/tFEn5VjP4aj/PhU14=
Date: Sat, 11 Jun 2011 14:02:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stratos Psomadakis <psomas@ece.ntua.gr>, Matt Mackall <mpm@selenic.com>,
        david@lang.hm, linux-kernel@vger.kernel.org,
        Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ketchup script and 3.0
Message-ID: <20110611060211.GB6522@cr0>
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>
 <1307451186.4204.953.camel@calx>
 <4DEE808D.6020405@ece.ntua.gr>
 <1307477435.4204.968.camel@calx>
 <4DEE8AD9.3050508@ece.ntua.gr>
 <1307479572.4204.977.camel@calx>
 <alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
 <1307480372.4204.987.camel@calx>
 <4DEE9695.7060805@ece.ntua.gr>
 <05cba294449b86a9aa22cec4abc7e98f.squirrel@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05cba294449b86a9aa22cec4abc7e98f.squirrel@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 02:33:53PM -0700, Randy Dunlap wrote:
>
>It's also an issue for scripts/patch-kernel, unless I decide
>to just kill (drop) it.
>

I think we should merge ketchup and then drop scripts/patch-kernel.
