Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0LHQqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:46:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0LHQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:46:32 -0500
Subject: Re: [PATCH] syslog: check cap_syslog when dmesg_restrict
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
        dwalsh@redhat.com, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101208164235.GA21062@mail.hallyn.com>
References: <20101208151901.GA20557@mail.hallyn.com>
	 <1291822780.3072.40.camel@localhost.localdomain>
	 <20101208164235.GA21062@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 11:46:23 -0500
Message-ID: <1291826783.3072.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 16:42 +0000, Serge E. Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):

> >   I think the code might be
> > incorrect today as well......
> > 
> > I thought the flow was supposed to be
> > 
> > if (capable(CAP_SYSLOG))
> > 	all good
> > else if (capable(CAP_SYS_ADMIN))
> > 	WARN, but still good for now
> 
> I prefer warn and deny.  Otherwise it's too easy to ignore warnings.  So
> I prefer the msg to be there to explain why it failed - not that I expect
> it to fail for anyone today.

Ok, fine with me.

Acked-by: Eric Paris <eparis@redhat.com>

