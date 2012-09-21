Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2IUGoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:44:09 -0400
Received: from mail.southpole.se ([193.12.106.18]:57424 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2IUGoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:44:07 -0400
X-Greylist: delayed 1089 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 02:44:07 EDT
Message-ID: <505C0880.9000008@southpole.se>
Date: Fri, 21 Sep 2012 08:26:08 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net
Subject: Re: [PATCH] audit: define AUDIT_ARCH_OPENRISC
References: <20120920224605.GA896@www.outflux.net>
In-Reply-To: <20120920224605.GA896@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.1(12242) on assp.southpole.se
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 08754-08528
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/21/2012 12:46 AM, Kees Cook wrote:
> When using audit on OpenRISC, an audit arch is needed. This defines
> it and fixes a compile-time bug uncovered in linux-next, likely from a
> cut/paste from an arch with 64/32-bit modes that defined arch_arch():
> arch/openrisc/kernel/ptrace.c:190:2: error: implicit declaration of function 'audit_arch'
>
> This replaces it with the newly defined AUDIT_ARCH_OPENRISC, since it
> is only 32-bit, and currently only operates in big-endian mode.

Looks good.  Will queue it up for 3.7.
Thanks,
Jonas
