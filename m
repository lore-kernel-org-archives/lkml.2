Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1DASMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:12:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab1DASMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:12:06 -0400
Date: Fri, 1 Apr 2011 20:11:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 0/4] Was: signal, ptrace: Fix delayed CONTINUED
	notification when ptraced
Message-ID: <20110401181123.GA9010@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org> <20110331151549.GA8458@redhat.com> <20110331163441.GF3385@htj.dyndns.org> <20110331172946.GA14934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331172946.GA14934@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Oleg Nesterov wrote:
>
> > I'll mull over it a bit more but please go ahead and create a proper
> > patch.
>
> Yes, will do tomorrow (and it needs the trivial re-diff against your tree).

OK, please consider this series for your tree.

4/3 is a bit off-topic, but imho makes sense right now.

Oleg.

