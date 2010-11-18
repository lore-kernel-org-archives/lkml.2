Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911Ab0KRXnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:43:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52064 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0KRXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:43:49 -0500
Date: Thu, 18 Nov 2010 15:42:41 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix memory leak
Message-ID: <20101118234241.GI19821@mail.oracle.com>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
	linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	ocfs2-devel@oss.oracle.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
 <1289034412-24278-4-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289034412-24278-4-git-send-email-jslaby@suse.cz>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 10:06:52AM +0100, Jiri Slaby wrote:
> Stanse found that o2hb_heartbeat_group_make_item leaks some memory on
> fail paths. Fix the paths by adding a new label and jump there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: ocfs2-devel@oss.oracle.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org

	This patch is now in the fixes branch of ocfs2.git.

Joel


-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
