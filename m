Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2AaFRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 00:17:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40843 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2AaFRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 00:17:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] sysctl: fix memset parameters in setup_sysctl_set()
References: <20120130134029.GC5926@elgon.mountain>
Date: Mon, 30 Jan 2012 21:20:31 -0800
In-Reply-To: <20120130134029.GC5926@elgon.mountain> (Dan Carpenter's message
	of "Mon, 30 Jan 2012 16:40:29 +0300")
Message-ID: <m1ty3c8n34.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19gSYNlHGgcQnjJ+/fOm0V6S+aYxH20m+c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> The current code is a nop.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied thanks.
