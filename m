Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1BQA4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:56:11 -0500
Received: from juliet.he.net ([184.105.210.2]:48865 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755758Ab1BQA4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:56:09 -0500
Date: Wed, 16 Feb 2011 16:56:03 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alan Ott <alan@signal11.us>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz,
        ospite@studenti.unina.it, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bgood@velocity.net
Subject: Re: [PATCH v4 1/2] HID: Documentation for hidraw
Message-Id: <20110216165603.fe8c342d.rdunlap@xenotime.net>
In-Reply-To: <4D5C202B.5030403@signal11.us>
References: <1297829209-10511-1-git-send-email-alan@signal11.us>
	<1297829209-10511-2-git-send-email-alan@signal11.us>
	<20110216071200.02ccdaa5@bike.lwn.net>
	<4D5C202B.5030403@signal11.us>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 14:06:19 -0500 Alan Ott wrote:

> On 02/16/2011 09:12 AM, Jonathan Corbet wrote:
> >>   Documentation/hid/Makefile      |    8 ++
> >>   Documentation/hid/hid-example.c |  167 +++++++++++++++++++++++++++++++++++++++
> >>      
> > I believe we're trying to get code - especially runnable code - out of the
> > Documentation tree.  Should this go under samples/ or, if it's useful
> > enough, under tools/?
> >    
> 
> Hi Jon,
> 
> Not a problem. I'd say samples/ over tools/ for this stuff. I'll re-spin 
> and re-submit.

and then
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
