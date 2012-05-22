Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2EVWmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:42:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2EVWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:42:37 -0400
Date: Tue, 22 May 2012 15:42:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] testusb: add path /dev/bus/usb to default search
 paths of usbfs
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A063A7C@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1205221542240.18325@chino.kir.corp.google.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A063A7C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Du, ChangbinX wrote:

> As real device-nodes managed by udev whose nodes lived in /dev/bus/usb
> are mostly used today, let testusb tool use that directory as one default
> path make tool be more convenient to use.
> 
> Signed-off-by: Du Changbin <changbinx.du@intel.com>

Acked-by: David Rientjes <rientjes@google.com>
