Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2AXXZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:25:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44120 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2AXXZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:25:33 -0500
Date: Tue, 24 Jan 2012 15:25:02 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124232502.GA22218@us.ibm.com>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
 <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com>
 <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124231601.GA4470@sergelap>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012423-6148-0000-0000-000002E27302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn [serge.hallyn@canonical.com] wrote:
| 
| That has nothing to do with /dev/pts/ptmx, whose perms are set based on
| the '-o ptmxmode=" argument, and default to 000 if not specified.  If
| /dev/ptmx is going to be a symlink to /dev/pts/ptmx, then we have to set
| the /dev/pts/ptmx perms to not be 000, or users won't be able to create
| ptys.

If we are going to make 'newinstance' the default, maybe the default
ptmx mode could be changed to 0666 in the kernel too ?

