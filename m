Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1EZFLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1EZFLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:11:15 -0400
Date: Thu, 26 May 2011 01:11:09 -0400
From: Dave Jones <davej@redhat.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: no sound in current -git
Message-ID: <20110526051109.GA11870@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>
References: <20110526013423.GA25226@redhat.com>
 <4DDDD47C.5030504@gmail.com>
 <20110526043337.GA11224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526043337.GA11224@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:33:38AM -0400, Dave Jones wrote:

 >  > sound over here is out as well on a macbook pro. seems gnome shell 
 >  > didn't like whats being merged with the current Mainline i.g. no sound 
 >  > bluetooth applet missing. will bisect when I get a chance.
 > 
 > Maybe it was this that just got merged..  (building now)
 > 
 > commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
 > Author: Eric Paris <eparis@redhat.com>
 > Date:   Wed May 25 19:49:18 2011 -0700
 > 
 >     tmpfs: fix XATTR N overriding POSIX_ACL Y

Yep. That fixes sound for me.
Sorry for the false alarm Takashi!

	Dave

