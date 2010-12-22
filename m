Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0LVBpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:45:16 -0500
Received: from ozlabs.org ([203.10.76.45]:44119 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0LVBpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:45:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Date: Wed, 22 Dec 2010 12:15:09 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: Dmitry Torokhov <dtor@vmware.com>, LKML <linux-kernel@vger.kernel.org>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com> <20101215235312.GA15328@dtor-ws.eng.vmware.com> <AANLkTikVku4u6jm6Um+pCAZbxrQo7vuaE+S3qjsY3XAJ@mail.gmail.com>
In-Reply-To: <AANLkTikVku4u6jm6Um+pCAZbxrQo7vuaE+S3qjsY3XAJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221215.10230.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 11:28:18 pm Alexey Dobriyan wrote:
> On Thu, Dec 16, 2010 at 1:53 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> > Yeah, I hate to disappoint them but it will break as soon as someone
> > adds a module_param() to one of the objects... That's even without my
> > changes.
> 
> Yeah, it should have been renamed to /sys/tristate :-\

Anyway, I've appled the patch.

Thanks,
Rusty.
