Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1CXV0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:26:54 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:58707 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756446Ab1CXV0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:26:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=I7cF9qYLUb23tzfNPAAyeXOCeie0387JSh+JUmkmk6sMvjO2V+KsKeEBFaPlG+5Un5eNr+Kw8XJcJ5wxMuPxGB+Op0r12J0PE7AdRW5RP/O/jGfuU6jE/qlm5nU0NDBJ;
Date: Thu, 24 Mar 2011 14:26:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: update documentation
Message-Id: <20110324142648.9f2565f7.rdunlap@xenotime.net>
In-Reply-To: <1300981741.32158.27.camel@e102109-lin.cambridge.arm.com>
References: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
	<1300981741.32158.27.camel@e102109-lin.cambridge.arm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 15:49:01 +0000 Catalin Marinas wrote:

> On Thu, 2011-03-24 at 14:49 +0000, Daniel Baluta wrote:
> > Besides x86 and arm, kmemleak now supports powerpc, sparc, sh,
> > microblaze and tile.
> > 
> > Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Applied to my documentation quilt queue.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
