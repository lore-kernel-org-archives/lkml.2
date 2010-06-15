Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0FOF3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 01:29:48 -0400
Received: from foo.birdnet.se ([213.88.146.6]:40051 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750826Ab0FOF3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 01:29:47 -0400
Message-ID: <20100615052944.7746.qmail@stuge.se>
Date: Tue, 15 Jun 2010 07:29:44 +0200
From: Peter Stuge <peter@stuge.se>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, debora@linux.vnet.ibm.com,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but
	not used
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, debora@linux.vnet.ibm.com,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost> <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost> <4C16F9FC.2080905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C16F9FC.2080905@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> > *baffled* Why did you think that would work? transmit_cmd()s signature
> > has 4 parameters.
> 
> I have no manual in front of me. Did a quick google, but came up with 
> (no hits) info on what that function does. grep showed too many entries 
> to really see why/what this is.

Check out the tool cscope. (Or kscope, if you prefer a GUI.)


//Peter
