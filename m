Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab2GDMOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:14:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35768 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2GDMOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:14:52 -0400
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120704120155.GE960@krava.redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
	 <1341397330.2507.85.camel@laptop> <1341398311.2507.98.camel@laptop>
	 <20120704120155.GE960@krava.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 14:14:48 +0200
Message-ID: <1341404088.2507.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 14:01 +0200, Jiri Olsa wrote:
> >   ret = sprintf(page, "event=0x%02llx", event);
> >   if (umask)
> >     ret += sprintf(page + ret, ",umask=0x%02llx", umask);
> >   if (inv)
> >     ret += sprintf(page + ret, ",inv");
> >   if (cmask)
> >     ret += sprintf(page + ret, ",cmask=0x%02llx", cmask);
> >   sprintf(page + ret, "\n");

There's a ret += missing there.

