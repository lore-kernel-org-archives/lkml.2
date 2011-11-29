Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1K2LLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:11:31 -0500
Received: from dion.org.ua ([193.104.35.143]:35286 "EHLO dion.org.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab1K2LL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:11:27 -0500
Date: Tue, 29 Nov 2011 13:11:06 +0200
From: Dmitry Nezhevenko <dion@inhex.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.1.3
Message-ID: <20111129111106.GA5335@laptop.local>
References: <20111127190735.GA11899@kroah.com>
 <20111128173708.GA3785@laptop.local>
 <20111128235052.GA21975@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128235052.GA21975@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 08:50:52AM +0900, Greg KH wrote:
> > I don't know where to report this, since bugzilla is still down. This
> > upgrade breaks UVC webcam that I've:
> > 
> > Bus 002 Device 002: ID 04f2:b029 Chicony Electronics Co., Ltd 1.3M UVC
> > Webcam
> > 
> > I'm getting followed while trying to capture from it:
> > 
> > 	[  187.555352] uvcvideo: Failed to submit URB 0 (-28).
> > 
> > Kernel 3.1.2 is definitely working.
> 
> Now fixed in 3.1.4, sorry about that.
> 

Works here. Thanks!

-- 
WBR, Dmitry
