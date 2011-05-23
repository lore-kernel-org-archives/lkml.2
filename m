Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab1EWVep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:34:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EWVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:34:44 -0400
Date: Mon, 23 May 2011 14:34:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/3] PM / Hibernate: Update kerneldoc comments in
 hibernate.c
Message-Id: <20110523143403.df275ba2.randy.dunlap@oracle.com>
In-Reply-To: <201105232311.28958.rjw@sisk.pl>
References: <201105211408.28671.rjw@sisk.pl>
	<201105211412.11782.rjw@sisk.pl>
	<4DD9CF9E.6000103@oracle.com>
	<201105232311.28958.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DDAD2D7.00A0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 23:11:28 +0200 Rafael J. Wysocki wrote:

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Update kerneldoc comments in hibernate.c
> 
> Some of the kerneldoc comments in kernel/power/hibernate.c are
> outdated and some of them don't adhere to the kernel's standards.
> Update them and make them look in a consistent way.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks good.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
