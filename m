Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab2BBX5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:57:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41767 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933644Ab2BBX5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:57:13 -0500
X-Sasl-enc: f3GLWX+EOHCeqsTr8GJwBe1R1kkE8qGw36f/Ij3ji44C 1328227032
Date: Thu, 2 Feb 2012 15:49:31 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 3/5] TTY: use tty_standard_install
Message-ID: <20120202234931.GB26647@kroah.com>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
 <1327954472-26594-3-git-send-email-jslaby@suse.cz>
 <20120202230518.GA18903@kroah.com>
 <4F2B1AF8.2000000@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2B1AF8.2000000@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:23:36AM +0100, Jiri Slaby wrote:
> On 02/03/2012 12:05 AM, Greg KH wrote:
> > On Mon, Jan 30, 2012 at 09:14:30PM +0100, Jiri Slaby wrote:
> >> Use the helper in the rest of the tty drivers. This is a simple
> >> replacement.
> > 
> > It would be, if you actually built this patch, as it is, it breaks :(
> 
> Yes, I replied to this patch that I sent you some broken bastard. Also I
> attached the correct version...

Odd, I missed that somehow, sorry about that.
