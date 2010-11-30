Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0K3XWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:22:11 -0500
Received: from SMTP02.SRV.CS.CMU.EDU ([128.2.217.197]:62410 "EHLO
	smtp02.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0K3XWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:22:09 -0500
Date: Tue, 30 Nov 2010 18:22:04 -0500
From: Eric Cooper <ecc@cmu.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101130232204.GF21496@localhost>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
 <20101117195843.GA31357@elf.ucw.cz>
 <20101117200614.GK15096@localhost>
 <20101130192053.GB5295@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130192053.GB5295@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please be consistent with rest of kernel...

There seem to be several ways this is done in existing sysfs drivers,
and most aren't documented yet in Documentation/ABI.

1. "0" and "1"
2. "enable" and "disable"
3. "enabled" and "disabled"
4. "enable" and "disable" when writing, but "enabled" and "disabled"
    when read back

Some require trailing "\n", others make it optional.

Which is the One True Way?

-- 
Eric Cooper             e c c @ c m u . e d u
