Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1EOIVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:21:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53211 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1EOIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ppxiuN7YA2+MSGW0+itvJ0zrqymb/vcmsusdob7UZ9tTtCR0uEZtXuHHCJqEgQfFEo
         w+fCpNlkoEUHHIOdOplmo91eXMfPQMLUlo8tR5O0B/nC4LGG67jBPFm7nLxwn+7DDBpi
         R0kQ8aB5fO9+L7CaS/Bk3iyH+5hfV9N2E3Mtc=
Date: Sun, 15 May 2011 11:21:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: bskeggs@redhat.com
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: Re: 2.6.39-rc7 nouveau vs KDE 4.6.2
Message-ID: <20110515082137.GA3882@p183>
References: <20110514231208.GA2947@p183>
 <20110515080929.GA2533@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515080929.GA2533@p183>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 11:09:29AM +0300, Alexey Dobriyan wrote:
> On Sun, May 15, 2011 at 02:12:08AM +0300, Alexey Dobriyan wrote:
> > After logging into KDE, I get garbage areas when say mouse moves over
> > icon in tray, or when window is opened fullscreen to the point it's
> > unusable.
> > 
> > Previous version of KDE (4.4.5?) was OK.
> > 
> > 
> > Linux version 2.6.39-rc7 (ad@p183) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #4 SMP PREEMPT Tue May 10 22:07:32 EEST 2011
> 
> FYI, 2.6.38.5 is no different.

Disable compositing/"desktop effects" (alt+shift+F12) works except
switch to fbconsole and back leaves screen black.
