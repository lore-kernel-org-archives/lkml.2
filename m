Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0KZD3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 22:29:18 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:43508
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752781Ab0KZD3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 22:29:17 -0500
Date: Fri, 26 Nov 2010 03:29:33 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopher J. PeBenito" <cpebenito@tresys.com>
Subject: Re: [PATCH 1/1] Define CAP_SYSLOG
Message-ID: <20101126032933.GA31340@mail.hallyn.com>
References: <20101125171132.GA25703@mail.hallyn.com>
 <20101125185857.fa237ddf.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125185857.fa237ddf.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Randy Dunlap (rdunlap@xenotime.net):
> On Thu, 25 Nov 2010 17:11:32 +0000 Serge E. Hallyn wrote:
> > +			/* remove after 2.6.28 */
> 
> 	Is this supposed to say: after 2.6.38 ??

:)  yup - i only noticed this after sending it, looking at
lkml.org, but didn't have a way of getting to my mail
server to reply to myself.

thanks,
-serge
