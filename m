Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2JINyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab2JINyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:54:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121009134537.GA23204@kroah.com>
References: <20121009134537.GA23204@kroah.com> <30767.1349789448@warthog.procyon.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for usb
Date: Tue, 09 Oct 2012 14:54:19 +0100
Message-ID: <31213.1349790859@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> > Can you merge the following branch into the usb tree please.
> 
> Is this (and the other pull requests for other subsystems) for 3.7 or
> for 3.8?

I don't really mind.  There are no dependencies on it.  Getting it in 3.7
means there's more chance it'll just apply when Linus does pull it.

David
