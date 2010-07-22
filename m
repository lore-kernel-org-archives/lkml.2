Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0GVSvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:51:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2034 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0GVSvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:51:31 -0400
Subject: Re: [PATCH 09/11] staging: comedi: formatting of pointers in
 printk()
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>
In-Reply-To: <20100722184557.GC32116@kroah.com>
References: <1279176172-5609-1-git-send-email-segooon@gmail.com>
	 <4C3EAEC5.8080908@gmail.com>  <20100722184557.GC32116@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 11:51:27 -0700
Message-ID: <1279824687.1909.55.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:45 -0700, Greg KH wrote:
> On Thu, Jul 15, 2010 at 08:46:29AM +0200, Jiri Slaby wrote:
> > On 07/15/2010 08:42 AM, Kulikov Vasiliy wrote:
> > The name and parameters suggest to remove the function completely. (And
> > use print_hex_dump_bytes instead.)
> I agree, Kulikov, can you make that chagne instead?

The function isn't used at all and should simply be removed.

