Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2A1TvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 14:51:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2A1TvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 14:51:17 -0500
Date: Sat, 28 Jan 2012 13:51:03 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120128195103.GA11299@sergelap>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
 <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com>
 <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap>
 <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kay Sievers (kay.sievers@vrfy.org):
> We might also thing about changing /sys/class/tty/ptmx/, and have the
> kernel create the symlink? The loops through userspace to setup
> default kernel stuff are kind of crazy ...
> 
> Kay

Hi Kay,

sorry, there is something I'm missing here.  Without a target kobj
to link to, how would we go about telling the kernel that /dev/ptmx
should be a symlink to /dev/pts/ptmx?  Is there a way to do that?

thanks,
-serge
