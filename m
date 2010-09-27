Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab0I0QpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:45:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881Ab0I0QpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:45:08 -0400
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal	secid
From: Eric Paris <eparis@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
        jengelh@medozas.de, paul.moore@hp.com, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
In-Reply-To: <4C9DB5CE.7090305@netfilter.org>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
	 <4C9DB5CE.7090305@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 12:44:05 -0400
Message-ID: <1285605845.2815.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 10:41 +0200, Pablo Neira Ayuso wrote:
> On 24/09/10 22:45, Eric Paris wrote:
> > Currently the nfconntrack export code sends the kernel internal secid to
> > userspace in a couple of proc files and over netlink as an integer.  This
> > is wrong.  This number is a kernel internal.  This patch changes the export
> > code to output either 0 or 1 for this value.  A future patch will implement
> > sending the name rather than the number in a new field.
> 
> I'm not sure why you need this transitional patch if you later on
> replace it.
> 
> Better to change the /proc output to make it consistent with patch 5/6?

Jan has stated his opinion I should not export the new secctx field via
the procfs interface.  This patch was included in the series in case
that was the consensus of the lists and thus we just wouldn't apply
patch 6/6 (which drops secmark and adds secctx to procfs)

-Eric

