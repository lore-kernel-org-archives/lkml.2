Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab1D0Wpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:45:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36340 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab1D0Wp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:45:27 -0400
Date: Wed, 27 Apr 2011 23:45:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427224524.GF9487@ZenIV.linux.org.uk>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
 <20110427164639.GD9487@ZenIV.linux.org.uk>
 <1303924079.18763.70.camel@gandalf.stny.rr.com>
 <20110427214657.GE9487@ZenIV.linux.org.uk>
 <BANLkTin_ZPDmXirK4MmmV5LaC6zmpb+qmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin_ZPDmXirK4MmmV5LaC6zmpb+qmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 07:17:11PM -0300, Thiago Farina wrote:
> > While we are at it, strcmp() is, indeed, a part of the language.
> 
> Part of the C standard library you mean, no?

Which is a part of the language.  Sure, our implementation happens to be
freestanding.  Most of C programmers you could find would have worked
with hosted implementations and would be familiar with the damn thing.

> >??See
> > section 7.21.4.2 in C99.
