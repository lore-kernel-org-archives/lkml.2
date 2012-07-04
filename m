Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab2GDKW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:22:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:39256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2GDKW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:22:57 -0400
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341352848-11833-5-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:22:55 +0200
Message-ID: <1341397375.2507.86.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> +static struct device_attribute event_attr_##_name = __ATTR_RO(_name)

Note that it would now be trivial to allow writing to this file to
update the kernel table.

