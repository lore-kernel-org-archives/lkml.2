Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1ITXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:00:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1ITXA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:00:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=GRY7tYrtr4DQ0ZOtdn4yMhHafutFL9MPR6Qu09duevz2oOF9bSOi7GCcIbMPaCqNL
	JeTuf9wrPlCeCjdUvRFoQ==
Date: Tue, 20 Sep 2011 16:00:12 -0700
From: Andrew Morton <akpm@google.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/2] kdump: Initialize vmcoreinfo note at startup
Message-Id: <20110920160012.53b941a7.akpm@google.com>
In-Reply-To: <20110920143400.776127689@linux.vnet.ibm.com>
References: <20110920143400.776127689@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 16:34:00 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> Hello Andrew,
> 
> Another common code patch that we would like to have upstream is the vmcoreinfo
> note initialization at Linux startup time. We need that for our traditional
> stand-alone and hypervisor dump tools.
> 
> [1] kdump: Initialize vmcoreinfo note at startup
> [2] s390: Export vmcoreinfo note
> 
> I already have discussed this with Vivek and he has acked the common code
> patch [1].
> 
> Do you agree that Martin sends these patches together with the kdump page
> table patches (see https://lkml.org/lkml/2011/9/15/55) in the next merge
> window?

Sounds good to me, thanks.
