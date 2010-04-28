Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab0D3Sv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:51:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45053 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758564Ab0D3RMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:12:50 -0400
Date: Wed, 28 Apr 2010 07:52:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH 2/5] PM / Hibernate: snapshot cleanup
Message-ID: <20100428055145.GA3721@ucw.cz>
References: <1272356118-10012-1-git-send-email-jslaby@suse.cz>
 <1272356118-10012-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272356118-10012-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-04-27 10:15:15, Jiri Slaby wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Remove support of reads with offset. This means snapshot_read/write_next
> now does not accept count parameter. It allows to clean up the functions
> and snapshot handle which no longer needs to care about offsets.
> 
> /dev/snapshot handler is converted to simple_{read_from,write_to}_buffer
> which take care of offsets.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
