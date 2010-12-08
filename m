Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0LHRxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:53:39 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43359 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0LHRxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:53:37 -0500
Date: Wed, 8 Dec 2010 09:53:16 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, dwalsh@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] syslog: check cap_syslog when dmesg_restrict
Message-ID: <20101208175316.GL5750@outflux.net>
References: <20101208151901.GA20557@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208151901.GA20557@mail.hallyn.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:19:01PM +0000, Serge E. Hallyn wrote:
> Eric Paris pointed out that it doesn't make sense to require
> both CAP_SYS_ADMIN and CAP_SYSLOG for certain syslog actions.
> So require CAP_SYSLOG, not CAP_SYS_ADMIN, when dmesg_restrict
> is set.
> 
> (I'm also consolidating the now common error path)
> 
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
