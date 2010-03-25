Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0CYF3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:29:55 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56607 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967Ab0CYF3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:29:53 -0400
Date: Thu, 25 Mar 2010 06:29:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 02/15] PM / Hibernate: snapshot cleanup
Message-ID: <20100325052929.GA12935@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269361063-3341-2-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-23 17:17:30, Jiri Slaby wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Remove support of reads with offset. This means snapshot_read/write_next
> now does not accept count parameter.
> 
> /dev/snapshot handler is converted to simple_read_from_buffer/simple_write_to_buffer.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

Well, if Al likes the vfs changes... why not.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
