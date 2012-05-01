Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2EAXY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:24:57 -0400
Received: from tex.lwn.net ([70.33.254.29]:35873 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805Ab2EAXY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:24:56 -0400
Date: Tue, 1 May 2012 17:24:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120501172454.0e811379@lwn.net>
In-Reply-To: <20120501192736.GA29770@srcf.ucam.org>
References: <20120501073711.028d31d6@lwn.net>
	<20120501110156.2b6e0561@lwn.net>
	<20120501171901.GA26006@srcf.ucam.org>
	<20120501120145.21f65ae2@lwn.net>
	<20120501183149.GA28536@srcf.ucam.org>
	<20120501123923.01ac1138@lwn.net>
	<20120501185455.GA29060@srcf.ucam.org>
	<20120501192736.GA29770@srcf.ucam.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012 20:27:36 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> What does removable in the parent device say? 

"unknown".

> In either case, does the 
> attached file help if dropped into /lib/udev/rules.d ?

Nope, no joy there.  

Thanks,

jon
