Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0KUUxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 15:53:44 -0500
Received: from SMTP01.SRV.CS.CMU.EDU ([128.2.217.196]:50892 "EHLO
	smtp01.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab0KUUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 15:53:43 -0500
Date: Sun, 21 Nov 2010 15:53:41 -0500
From: Eric Cooper <ecc@cmu.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101121205341.GB28164@localhost>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117160919.GC10992@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 08:09:19AM -0800, Greg KH wrote:
> Documentation/ABI is the correct place for it.

Should I just add descriptions of the additional attributes to the end
of the existing Documentation/ABI/testing/sysfs-class-led file?  If
so, how should I indicate that these attributes pertain only when the
ledtrig-netdev trigger is in use?

Or should I create a file specific to this trigger, and if so, what
should it be named?

-- 
Eric Cooper             e c c @ c m u . e d u
