Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab2EIOUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:20:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63999 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2EIOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:20:09 -0400
Date: Wed, 9 May 2012 07:20:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrey Rahmatullin <wrar@wrar.name>
Subject: Re: [ 116/167] [PATCH] USB: EHCI: fix crash during suspend on ASUS
 computers
Message-ID: <20120509142004.GA11695@kroah.com>
References: <20120509055045.705106794@decadent.org.uk>
 <4FAA0DC8.5050602@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA0DC8.5050602@fisher-privat.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 08:25:12AM +0200, Oleksij Rempel wrote:
> What is actually with acpi fix of this problem? Will be this patch
> removed and acpi fix applied instead?

When that acpi fix goes into the tree, yes, that will happen.  Until
then, this patch solves the problem for a number of users.

thanks,

greg k-h
