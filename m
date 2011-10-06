Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009Ab1JFQoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:44:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:34546 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668Ab1JFQoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:44:11 -0400
Date: Thu, 6 Oct 2011 12:44:06 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Fabrice Jouhaud <yargil@free.fr>, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] [SIGNED-OFF] ext4: don't work without procfs
Message-ID: <20111006164406.GC19049@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Fabrice Jouhaud <yargil@free.fr>, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
References: <1317916276-2509-1-git-send-email-yargil@free.fr>
 <1317916878.1823.2.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317916878.1823.2.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 09:01:18AM -0700, Joe Perches wrote:
> On Thu, 2011-10-06 at 17:51 +0200, Fabrice Jouhaud wrote:
> > From: Yargil <yargil@free.fr>
> 
> It would be better to use your full name on the "From: " line

In fact, in these cases I will normally copy the full name from
Signed-off-by to the From line before applying the patch.  (In general
the signed-off-by line and the From line should have the same contents.)

    		       	       	    	 - Ted

P.S.  Helpful tip: if you use emacs, try putting something like this
in your .emacs.el file:

(defun insert-signed-off-by ()
  (interactive)
  (insert "Signed-off-by: Fabrice Jouhaud" <yargil@free.fr>\n"))

(global-set-key "\^Cs" 'insert-signed-off-by)
