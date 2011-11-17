Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1KQBwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:52:19 -0500
Received: from aa.linuxbox.com ([134.215.213.37]:4034 "EHLO aa.linuxbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1KQBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:52:18 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 20:52:18 EST
Date: Wed, 16 Nov 2011 20:46:15 -0500 (EST)
From: "Matt W. Benjamin" <matt@linuxbox.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: John Hughes <john@calvaedi.com>,
        Trond Myklebust <trond.myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Rees <rees@umich.edu>
Message-ID: <76928528.162.1321494375223.JavaMail.root@thunderbeast.private.linuxbox.com>
In-Reply-To: <20111116203119.1d9c0dd6@corrin.poochiereds.net>
Subject: Re: [PATCH] Don't hang user processes if Kerberos ticket for nfs4
 mount expires
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.0.14]
X-Mailer: Zimbra 6.0.5_GA_2180.CentOS5_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.5_GA_2180.CentOS5_64)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (aa.linuxbox.com [10.1.1.1]); Wed, 16 Nov 2011 20:46:18 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While I'm not expert in this area, my impression had been that the established
practice was that used with AFS, i.e., run jobs under a process capable of renewing
kerberos tickets, e.g., kstart (http://www.eyrie.org/~eagle/software/kstart/).

Matt

----- "Jeff Layton" <jlayton@redhat.com> wrote:

> The previous situation was also a recipe for disaster, and was often
> cited as a primary reason why people didn't want to deploy kerberized
> NFS. Having everything fall down and go boom when your ticket expires
> is not desirable either.
> 
> I suppose we'll have to agree to disagree on this point. That said,
> I'm
> open to sane suggestions however that don't regress the behavior for
> those users who need to be able to cope with expired tickets.
> 
> -- 
> Jeff Layton <jlayton@redhat.com>

-- 

Matt Benjamin

The Linux Box
206 South Fifth Ave. Suite 150
Ann Arbor, MI  48104

http://linuxbox.com

tel. 734-761-4689
fax. 734-769-8938
cel. 734-216-5309
