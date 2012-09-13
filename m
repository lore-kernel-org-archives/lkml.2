Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab2IMLwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:52:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55465 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757703Ab2IMLwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:52:01 -0400
Date: Thu, 13 Sep 2012 15:51:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120913115157.GH19956@moon>
References: <20120913095623.GB28508@moon>
 <5051C7AD.7050005@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051C7AD.7050005@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:46:53PM +0200, Jiri Slaby wrote:
> On 09/13/2012 11:56 AM, Cyrill Gorcunov wrote:
> > For checkpoint/restore we need to know if tty has
> > exclusive or packet mode set, as well as if pty
> > is currently locked. Just to be able to restore
> > this characteristics.
> > 
> > For this sake the following ioctl codes are introduced
> > 
> >  - TIOGPKT to get packet mode state
> >  - TIOGPTLCK to get Pty locked state
> >  - TIOGEXCL to get Exclusive mode state
> 
> Hi! I have only a comment regarding the naming. Why not to follow TIOC*?

Hi Jiri, yeah, seems to be a good idea. I'll update if there will be no
objection about idea in general. Thanks!

	Cyrill
