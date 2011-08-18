Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HRTWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:22:34 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46152 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752193Ab1HRTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:22:32 -0400
Date: Thu, 18 Aug 2011 12:22:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: fa.linux.kernel@googlegroups.com
Cc: lucasrangit <lucasrangit@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stelian Pop <stelian@popies.net>
Subject: Re: [RFC] Linux Kernel Subversion Howto
Message-Id: <20110818122230.5850cc65.rdunlap@xenotime.net>
In-Reply-To: <663e2737-03b8-453d-a344-6d87b1b44d9b@glegroupsg2000goo.googlegroups.com>
References: <fa.hd724f5.h36q2j@ifi.uio.no>
	<663e2737-03b8-453d-a344-6d87b1b44d9b@glegroupsg2000goo.googlegroups.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 12:08:24 -0700 (PDT) lucasrangit wrote:

> This was very helpful Stelian. Is anyone maintaining http://www.moses.uklinux.net/patches/dontdiff for those of us that still have to use Subversion? I'd like to add "modules.order" and "modules.builtin" to the list.
> --

Those files are already listed in <kerneltree>/Documentation/dontdiff,
which I do occasionally update.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
