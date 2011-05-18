Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab1ERQD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:03:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43161 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab1ERQDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:03:25 -0400
Date: Wed, 18 May 2011 13:03:17 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Olaf Hartmann <o.hartmann@telovital.com>
Subject: Re: [RFC/RFT PATCH] Staging: et131x: add suspend/resume support
Message-ID: <20110518160316.GA3502@herton-IdeaPad-Y430>
References: <1305724667-2980-1-git-send-email-herton.krzesinski@canonical.com>
 <20110518152428.GA8106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518152428.GA8106@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:24:28AM -0700, Greg KH wrote:
> On Wed, May 18, 2011 at 10:17:47AM -0300, Herton Ronaldo Krzesinski wrote:
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> I think we need a bit more comments here.
> 
> Like have you tested this to verify that it works?  Anything else?

An user complained about lack of suspend/resume support, so I did the
patch, it's working accordingly to him from what I could get
(unfortunately I can't test myself, don't have the hardware). I want
others to test too, before this can be pushed (RFT on subject). The bug
report I got: http://bugs.launchpad.net/bugs/766549
But good luck in parsing that... I also want others with same
hardware testing this, to confirm it is ok.

May be this isn't important at this stage, the driver may need another
important things done before...

> 
> thanks,
> 
> greg k-h
> 

-- 
[]'s
Herton
