Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2JIODr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:03:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59906 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2JIODo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:03:44 -0400
Date: Tue, 9 Oct 2012 07:03:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for usb
Message-ID: <20121009140340.GA13529@kroah.com>
References: <20121009134537.GA23204@kroah.com>
 <30767.1349789448@warthog.procyon.org.uk>
 <31213.1349790859@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31213.1349790859@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:54:19PM +0100, David Howells wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > Can you merge the following branch into the usb tree please.
> > 
> > Is this (and the other pull requests for other subsystems) for 3.7 or
> > for 3.8?
> 
> I don't really mind.  There are no dependencies on it.  Getting it in 3.7
> means there's more chance it'll just apply when Linus does pull it.

Ok, thanks, I'll queue these up after 3.7-rc1 is out.

greg k-h
