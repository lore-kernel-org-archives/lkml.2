Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2EASBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:01:48 -0400
Received: from tex.lwn.net ([70.33.254.29]:34510 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab2EASBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:01:47 -0400
Date: Tue, 1 May 2012 12:01:45 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120501120145.21f65ae2@lwn.net>
In-Reply-To: <20120501171901.GA26006@srcf.ucam.org>
References: <20120501073711.028d31d6@lwn.net>
	<20120501110156.2b6e0561@lwn.net>
	<20120501171901.GA26006@srcf.ucam.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012 18:19:01 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On its own, this should do precisely nothing.

Nonetheless, at the previous patch
(0846e7e9856c0928223447d9349a877202a63f24, usb: Add support for indicating
whether a port is removable) things work.  With this one, they don't.  

> What userspace are you 
> running, and what does the removable node in the sysfs entry for the 
> dongle's USB device say?

It's Rawhide, updated yesterday.  "Removable" says "fixed".

FWIW, power/runtime_status reads "suspended" most of the time.  By banging
on the keyboard I can get it to "active", but it goes back to "suspended"
even with continuous activity.  Weirdly, the keyboard continues to work if
I keep hitting keys.

Thanks,

jon
