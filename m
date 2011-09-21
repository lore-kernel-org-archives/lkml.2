Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1IUItN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:49:13 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:38865 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IUItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:49:12 -0400
Subject: Re: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@google.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110920155912.d107fd49.akpm@google.com>
References: <20110920143400.776127689@linux.vnet.ibm.com>
	 <20110920143436.019045253@linux.vnet.ibm.com>
	 <20110920155912.d107fd49.akpm@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 21 Sep 2011 10:49:08 +0200
Message-ID: <1316594948.3888.3.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Tue, 2011-09-20 at 15:59 -0700, Andrew Morton wrote:
> On Tue, 20 Sep 2011 16:34:01 +0200

[snip]

> Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> > -void crash_save_vmcoreinfo(void)
> > +static void update_vmcoreinfo_note(void)
> >  {
> > -	u32 *buf;
> > +	u32 *buf = (u32 *) vmcoreinfo_note;
> 
> The cast is unneeded?

Correct. I removed the cast (with the blank :), thanks!

Michael

