Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1CPUUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:20:53 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42506 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1CPUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:20:46 -0400
Subject: Re: [ANNOUNCE] usbmon capture and parser script
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Date: Wed, 16 Mar 2011 21:20:24 +0100
In-Reply-To: <20110316194758.GA32557@kroah.com>
References: <4D8102A9.9080202@redhat.com> <20110316194758.GA32557@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-2.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1300306845.1954.7.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 12:47 -0700, Greg KH wrote:
> Very cool stuff.  You are away of:
> 	http://vusb-analyzer.sourceforge.net/
> right?
> 
> I know you are doing this in console mode, but it looks close to the
> same idea.

Perhaps there should be some references to vusb-analyzer and similar
tools in Documentation/usb/usbmon.txt (it now only mentions "usbdump"
and "USBMon"). I remember looking for a tool like that (ie, a parser)
for quite some time before stumbling onto vusb-analyzer.


Paul Bolle

