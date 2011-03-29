Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1C2PfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:35:18 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54707 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751301Ab1C2PfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:35:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MIhDCcLt4nkhGkZftZ+88ONs1UUElXvPNdC6HVIoT3zbxFwBs/0FhWNCmwxlGdFLpOJP7gJTLkyaOtErK/ixkZRwxuZr1SP2FbndIk5krfktHhTtFsdU8ccPOmiOgOn7;
Date: Tue, 29 Mar 2011 08:33:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, catalin.marinas@arm.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: update documentation
Message-Id: <20110329083334.f33742bd.rdunlap@xenotime.net>
In-Reply-To: <AANLkTi=Kr5DQrZW+d=u-fyYcDNQogBj=TFr1_25+Z4Uw@mail.gmail.com>
References: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
	<20110329073632.GB10163@osiris.boeblingen.de.ibm.com>
	<AANLkTi=Kr5DQrZW+d=u-fyYcDNQogBj=TFr1_25+Z4Uw@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 10:51:33 +0300 Daniel Baluta wrote:

> >> +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
> >
> > You missed s390.
> 
> You are right.
> 
> Randy, should I send a v2 of this patch, or is it already applied?
> Another option would be to send a separate patch adding s390,
> on top of my previous patch.

Your patch is still in my patch queue, so please send me a full replacement
patch for it.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
