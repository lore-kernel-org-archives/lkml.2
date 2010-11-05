Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab0KEEoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 00:44:15 -0400
Received: from mail.perches.com ([173.55.12.10]:4233 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0KEEoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 00:44:14 -0400
Subject: Re: [PATCH 49/49] virt/kvm/kvm_main.c: Use vzalloc
From: Joe Perches <joe@perches.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Jiri Kosina <trivial@kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CD38723.5000303@oss.ntt.co.jp>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <e57b4ed114851004b2839cb449937fc657634362.1288925425.git.joe@perches.com>
	 <4CD38723.5000303@oss.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 21:44:12 -0700
Message-ID: <1288932252.18440.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 13:25 +0900, Takuya Yoshikawa wrote:
> (2010/11/05 12:08), Joe Perches wrote:
> > Signed-off-by: Joe Perches<joe@perches.com>
> > ---
> >   virt/kvm/kvm_main.c |   13 +++----------
> >   1 files changed, 3 insertions(+), 10 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> 
> Already changed to vzalloc(), see kvm.git.

Thanks.  No worries.

fyi: the kvm git isn't in MAINTAINERS.

Perhaps something like this is appropriate
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ec7e4a4..73bfe4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3443,6 +3443,7 @@ M:	Avi Kivity <avi@redhat.com>
 M:	Marcelo Tosatti <mtosatti@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 S:	Supported
 F:	Documentation/*/kvm.txt
 F:	arch/*/kvm/


