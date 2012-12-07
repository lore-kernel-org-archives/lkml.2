Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2LGXa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:30:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51608 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2LGXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:30:58 -0500
Date: Fri, 7 Dec 2012 15:30:53 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Constantine Shulyupin <const@makelinux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: question about configfs_attribute
Message-ID: <20121207233053.GO22789@localhost>
Mail-Followup-To: Constantine Shulyupin <const@makelinux.com>,
	linux-kernel@vger.kernel.org
References: <CAE7jHC9UuokkM9EqkuO0Z-NZ4MTb49LdinZGpXZ+Vt+5D7fiHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7jHC9UuokkM9EqkuO0Z-NZ4MTb49LdinZGpXZ+Vt+5D7fiHg@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 01:45:56PM +0200, Constantine Shulyupin wrote:
> Hi
> 
> I wonder why show and store methods are not stored inside of
> configfs_attribute but stored in wrapper struct defined with
> CONFIGFS_ATTR_STRUCT ?

	If you created a custom attribute struct and methods for
yourself, you would not have to have the show/store methods on the same
structure.  The structure, and the ##item_show/store macros, are a
convenience way to do it.
	It certainly could be done differently.  I cloned the sysfs
approach at the time.  Note that sysfs has a different methodology for
defining attributes now.

Joel

-- 

Life's Little Instruction Book #252

	"Take good care of those you love."

			http://www.jlbec.org/
			jlbec@evilplan.org
