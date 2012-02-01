Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2BAWbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:31:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2BAWbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:31:46 -0500
Date: Wed, 1 Feb 2012 17:31:01 -0500
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] sysfs:  Optionally count subdirectories to support buggy
 applications
Message-ID: <20120201223100.GA20086@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <4F27120A.4040106@suse.cz>
 <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
 <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehueyz20.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 02:21:59PM -0800, Eric W. Biederman wrote:
 
 > +config SYSFS_COUNT_LINKS
 > +	bool "sysfs count subdirectoires to support buggy applications"

subdirectories

 > +	Increase the memory and cpu untilization of sysfs by maintaining

utilization

 > +	as the number of subdirectories plus two.  With out this enabled

Without

 > +	the standard way of indicating that the number of subdirectoires

subdirectories


	Dave
