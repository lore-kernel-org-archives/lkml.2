Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1BDQDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:03:08 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:52377
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752764Ab1BDQDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:03:07 -0500
Date: Fri, 4 Feb 2011 16:03:46 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: david@lang.hm
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110204160346.GA17396@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
 <1296748401.14846.39.camel@moria>
 <20110203165132.GA28172@mail.hallyn.com>
 <alpine.DEB.2.00.1102031647150.30983@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102031647150.30983@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting david@lang.hm (david@lang.hm):
> I can see what you would want to allow for a syslog daemon to have
> CAP_SYSLOG without needing to have CAP_SYS_ADMIN, but why do you see
> it as important to deny the ability if someone has CAP_SYS_ADMIN?

Good point, most of its use is in going the other way.

-serge
