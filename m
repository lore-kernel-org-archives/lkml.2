Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab2EaEUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 00:20:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:58051 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2EaEUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:20:33 -0400
Date: Thu, 31 May 2012 14:20:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
In-Reply-To: <20120531002802.GA11775@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.2.02.1205311419480.22190@tundra.namei.org>
References: <1337807899.15138.31.camel@falcor> <20120530043443.GA3200@ZenIV.linux.org.uk> <20120530163605.GV11775@ZenIV.linux.org.uk> <1338406967.2257.24.camel@localhost> <20120530202427.GW11775@ZenIV.linux.org.uk> <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
 <20120530205612.GY11775@ZenIV.linux.org.uk> <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com> <20120530213638.GZ11775@ZenIV.linux.org.uk> <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
 <20120531002802.GA11775@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Al Viro wrote:

> I've pushed that to the same place (vfs.git#security_file_mmap).  Should
> propagate to git.kernel.org in a few...  Guys, does anybody have objections
> about the way it looks?

Nope.

Acked-by: James Morris <james.l.morris@oracle.com>

