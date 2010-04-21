Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0DUDE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 23:04:29 -0400
Received: from kroah.org ([198.145.64.141]:53001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab0DUDE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 23:04:27 -0400
Date: Tue, 20 Apr 2010 19:54:11 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/3] p9auth: add CAP_GRANT_ID to authorize use of
	/dev/caphash
Message-ID: <20100421025411.GA10258@kroah.com>
References: <20100421012749.GA21338@us.ibm.com> <20100421012815.GA24251@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421012815.GA24251@us.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 08:28:15PM -0500, Serge E. Hallyn wrote:
> 
> Granting userid capabilities to another task is a dangerous
> privilege.  Don't just let file permissions authorize it.
> Define CAP_GRANT_ID as a new capability needed to write to
> /dev/caphash.

Isn't there some man page that also needs to be updated when you add
something like this to the user/kernel api?

thanks,

greg k-h
