Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2FMXPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:15:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2FMXPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:15:43 -0400
Date: Wed, 13 Jun 2012 16:15:39 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] testusb: add path /dev/bus/usb to default search
 paths of usbfs
Message-ID: <20120613231539.GA8891@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A063A7C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A063A7C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 06:50:24AM +0000, Du, ChangbinX wrote:
> As real device-nodes managed by udev whose nodes lived in /dev/bus/usb
> are mostly used today, let testusb tool use that directory as one default
> path make tool be more convenient to use.
> 
> Signed-off-by: Du Changbin <changbinx.du@intel.com>

This patch does not apply, what tree did you make it against?  Can you
redo it against the next linux-next release and resend it so I can apply
it?

thanks,

greg k-h
