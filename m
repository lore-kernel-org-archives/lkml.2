Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0HKPIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:08:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:43026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0HKPIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:08:06 -0400
Date: Wed, 11 Aug 2010 08:07:46 -0700
From: Greg KH <gregkh@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Break the kobject namespace defs into their own header
Message-ID: <20100811150746.GA9070@suse.de>
References: <20100811140102.19596.84876.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811140102.19596.84876.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 03:01:02PM +0100, David Howells wrote:
> Break the kobject namespace defs into their own header to avoid a header file
> inclusion ordering problem between linux/sysfs.h and linux/kobject.h.

What "ordering problem" is there?  I don't see a build error here, do
you?

thanks,

greg k-h
