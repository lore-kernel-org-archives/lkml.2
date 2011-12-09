Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1LIBF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:05:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:33161 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1LIBFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:05:54 -0500
Date: Fri, 9 Dec 2011 12:05:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][patch series] vfsmount gutting
In-Reply-To: <20111208010251.GF2203@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.2.00.1112091202060.19846@tundra.namei.org>
References: <20111208010251.GF2203@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       What is missing:
> 1) Review.  As far as I can see on local testing, the thing works, but extra
> eyes would obviously be very welcome.

I've been through the code and not seen any issues, and I'm also running 
it on my dev box with SELinux on, with no apparent problems.

If anyone has the SELinux testsuite set up, it would be good to run it 
with these patches applied.



- James
-- 
James Morris
<jmorris@namei.org>
