Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1DMPeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab1DMPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:34:14 -0400
Date: Wed, 13 Apr 2011 17:33:59 +0200
From: Petr Pisar <ppisar@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] Clean console safely
Message-ID: <20110413153359.GC2993@dhcp-0-146.brq.redhat.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Artem Bityutskiy <dedekind1@gmail.com>
References: <1302705651.2768.21.camel@localhost>
 <1302706473-16519-1-git-send-email-ppisar@redhat.com>
 <20110413150113.GA8121@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110413150113.GA8121@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 08:01:13AM -0700, Greg KH wrote:
> On Wed, Apr 13, 2011 at 04:54:33PM +0200, Petr Písař wrote:
> > Traditional \E[2J sequence erases console display but scroll-back
> > buffer and underlying device (frame) buffer keep data that can be
> > accessed by scrolling console back.
> > 
> > This patch introduce new \E[J parameter 3 that allows to scramble
> > scroll-back buffer explicitly. Session locking programs (screen,
> > vlock) can use it to prevent attacker to browse locked console
> > history.
> 
> Is this also documented somewhere so that people know about it?
> 
> 
Not yet as this is fresh feature. I'd like to put few words into
console_codes(4). I guess manual sources are not part of Linux.

-- Petr
