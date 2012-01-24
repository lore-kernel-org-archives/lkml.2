Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2AXX2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:28:16 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:49055 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2AXX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:28:14 -0500
Date: Tue, 24 Jan 2012 23:29:54 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124232954.GA26607@hallyn.com>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
 <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com>
 <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap>
 <20120124232502.GA22218@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124232502.GA22218@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> Serge Hallyn [serge.hallyn@canonical.com] wrote:
> | 
> | That has nothing to do with /dev/pts/ptmx, whose perms are set based on
> | the '-o ptmxmode=" argument, and default to 000 if not specified.  If
> | /dev/ptmx is going to be a symlink to /dev/pts/ptmx, then we have to set
> | the /dev/pts/ptmx perms to not be 000, or users won't be able to create
> | ptys.
> 
> If we are going to make 'newinstance' the default, maybe the default
> ptmx mode could be changed to 0666 in the kernel too ?
> 

Right that was what i meant :)

thanks,
-serge
