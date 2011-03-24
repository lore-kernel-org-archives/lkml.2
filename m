Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1CXJke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1CXJkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:40:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTikUYp6YxryaBcpCrs3XwxkvHZZSk5x3S4yNcD4c@mail.gmail.com>
References: <AANLkTikUYp6YxryaBcpCrs3XwxkvHZZSk5x3S4yNcD4c@mail.gmail.com> <1300826506-23192-1-git-send-email-vapier@gentoo.org> <10444.1300926012@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, graf.yang@analog.com, uclinux-dev@uclinux.org,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: support SMP dynamic percpu_alloc
Date: Thu, 24 Mar 2011 09:40:08 +0000
Message-ID: <22366.1300959608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> i havent seen the build error you mention below, but i think that's
> because in a past discussion we determined that NOMMU ports should be
> setting VMALLOC_START to 0 and VMALLOC_END to -1.  is that no longer
> the case ?

Given that there's an explicit test now, I feel we should use it where
appropriate.  I'll have a look to see what else might be renderable to that
test.

David
