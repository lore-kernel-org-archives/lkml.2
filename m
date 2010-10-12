Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0JLX25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 19:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0JLX2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 19:28:55 -0400
Subject: Re: [PATCH 5/5] secmark: export secctx, drop secmark in procfs
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <paul.moore@hp.com>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, jmorris@namei.org, selinux@tycho.nsa.gov,
        sds@tycho.nsa.gov, jengelh@medozas.de,
        linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
        pablo@netfilter.org
In-Reply-To: <1286925596.5133.102.camel@sifl>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <20101012154035.26943.35175.stgit@paris.rdu.redhat.com>
	 <1286925596.5133.102.camel@sifl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 19:27:43 -0400
Message-ID: <1286926063.2614.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 19:19 -0400, Paul Moore wrote:
> On Tue, 2010-10-12 at 11:40 -0400, Eric Paris wrote:
> > The current secmark code exports a secmark= field which just indicates if
> > there is special labeling on a packet or not.  We drop this field as it
> > isn't particularly useful and instead export a new field secctx= which is
> > the actual human readable text label.
> 
> Looks reasonable to me, just some small nits/questions below ...

Will switch to u32 in -v2.

-Eric

