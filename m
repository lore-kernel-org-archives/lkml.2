Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031799Ab2CSPEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:04:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031623Ab2CSPEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:04:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120318235114.GA30497@thor.bakeyournoodle.com>
References: <20120318235114.GA30497@thor.bakeyournoodle.com> <20120318184105.GC2095@windriver.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: dhowells@redhat.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 18, 2012
Date: Mon, 19 Mar 2012 15:03:57 +0000
Message-ID: <1121.1332169437@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds <tony@bakeyournoodle.com> wrote:

> > 	frv:defconfig  (arch/frv/kernel/head.S operand out of range)

What binutils are you using?  I suspect this is fixed by a patch that only
went upstream very recently.  Are you using a 64-bit machine to do your
compilation?

David
