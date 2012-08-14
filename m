Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2HNRbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:31:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62376 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2HNRb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:31:28 -0400
Date: Tue, 14 Aug 2012 10:31:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120814173124.GO25632@google.com>
References: <20120730213656.0a9f6d30@neptune.home>
 <20120809200947.2194e89f@neptune.home>
 <20120813232708.GF25632@google.com>
 <20120814083044.78b401d2@pluto.restena.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120814083044.78b401d2@pluto.restena.lu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 08:30:44AM +0200, Bruno Prémont wrote:
> > I'm kinda shooting in the dark but who flushes / cancels
> > fb_info->deferred_work?
> 
> fb_deferred_io_cleanup() does so and is called by destroy fbops
> (when last reference to fb_info is returned):

I see.  Sorry but just from glancing it I can't really tell what's
going wrong.

Thanks.

-- 
tejun
