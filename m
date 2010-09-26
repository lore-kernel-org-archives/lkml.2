Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab0IZSXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:23:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:33624 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab0IZSXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:23:42 -0400
Date: Sun, 26 Sep 2010 14:23:38 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Tracey Dent <tdent48227@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] Fs: ext4: namei: fixed file of checkpatch/pl
 warnings and errors
Message-ID: <20100926182338.GM19690@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Tracey Dent <tdent48227@gmail.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <1285439521-2557-10-git-send-email-tdent48227@gmail.com>
 <m3pqw16mfh.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3pqw16mfh.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 08:36:34AM +0200, Krzysztof Halasa wrote:
> 
> BTW I wouldn't trust checkpatch so blindly. Also keep in mind checkpatch
> is only a tool and that maintainers have full authority to ignore the
> problems (or "problems") it spews.

I'm beginning to think we need to have an entry in the kernel newbie's
FAQ warning people that the output of various scripts such as
checkpatch and get_maintainer are not authoratative, and are
hueristics intended to be supplemented by human intelligence.

	   	       	  	       	  	- TEd
