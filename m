Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab2J0Pp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:45:58 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:52881 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab2J0Ppz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:45:55 -0400
Date: Sat, 27 Oct 2012 17:45:49 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@linuxfoundation.org
Cc: clouds.yan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] debugfs: pass NULL as the last parameter of
 debugfs_print_regs32()
Message-ID: <20121027154549.GA7132@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20121027150715.GD3349@kroah.com>
References: <20121027150715.GD3349@kroah.com>
  <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This function is only used (twice) by the author of it, and the
>> 'prefix' feature is never used.

I introduced it to shrink some internal code that had a lot of
repetition in the debugfs files implementation. In that context I use
the prefix string.  Some of the code had later been submitted, but not
yet all of it.  Later work by Davide Ciminaghi moved our MFD user to
the regmap interface, according to maintainer's suggestion (which
however means loosing register names from the debugfs dump).

> If the parameter isn't being used, please, just delete it.

It is not currently used by upstream callers, but the function itself
uses it as documented (Documentation/...).  I wouldn't remove the
feature and introduce an incompatibility just for this.

/alessandro
