Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2GIQR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:17:26 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38060 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2GIQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:17:25 -0400
Date: Mon, 9 Jul 2012 12:17:22 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: "random PID" - worth to be considered (again)  ?
Message-ID: <20120709161722.GB7104@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <4FFAE24A.2070404@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FFAE24A.2070404@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:53:14PM +0200, Toralf Förster wrote:
> After reading [1] I'm wondering whether these would at least improve
> OpenSSL's implementation of a RSA key generator (page 13 in [1]) ?

Random PID's is a terribly way to get entropy into OpenSSL.  You don't
get that many bits of entropy that way, and what bits of randomness
you get is coming from /dev/urandom.  So improving the randomness of
/dev/urandom is what's important.

Regards,

					- Ted
