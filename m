Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2LESN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:13:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2LESN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:13:58 -0500
Date: Wed, 5 Dec 2012 10:13:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sles 11 sp2 srp and multipath issues
Message-ID: <20121205181353.GA2042@kroah.com>
References: <CACaajQux0owmraiWmRbMLiO1oxFefP+PdiQKs1zgzrj7kcD=AA@mail.gmail.com>
 <20121126183538.GA18590@kroah.com>
 <CACaajQsqKDNkMQ6+1bPNgVf6A7DAfC1ZiMBVwQKODHnq2yS-OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACaajQsqKDNkMQ6+1bPNgVf6A7DAfC1ZiMBVwQKODHnq2yS-OA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 10:06:45PM +0400, Vasiliy Tolstov wrote:
> 2012/11/26 Greg KH <gregkh@linuxfoundation.org>:
> >
> > If you use a kernel.org released kernel, then we can help you out.
> >
> > Best of luck,
> 
> Okay. I'm use kernel from you git tree (3.0.53 stable branch). But
> have no luck. Ahen i'm force reboot storage server multipath -ll on
> initiator side locked.
> echo w > /proc/sysrq-trigger says:

3.0-stable is still quite old, can you duplicate this on the latest 3.6
kernel?

Also, if you have multipath issues, please cc: the multipath developers,
they are the ones that can best help you out here.

greg k-h
