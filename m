Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0FQToh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:44:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab0FQTog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:44:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Date: Thu, 17 Jun 2010 21:44:31 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net> <20100617172828.GA24362@kroah.com> <20100617191516.GA15963@c-98-229-117-200.hsd1.ma.comcast.net>
In-Reply-To: <20100617191516.GA15963@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006172144.31869.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+6DaD23eWkttJWu20YXIUxK4xjiBHKfHFDuQr
 4UuE1OJxYcWm+ItbWOgCngoHnn5vjy919dekRwfAlrajneM7il
 Nnvg0e/5x9cxXwabSi6ZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 June 2010 21:15:16 Jeff Dike wrote:

>     The Hayes ESP driver has been removed from the tree:
>         commit f53a2ade0bb9f2a81f473e6469155172a96b7c38
>         ("tty: esp: remove broken driver")
>     so its ioctls aren't needed any more.
> 
>     Signed-off-by: Jeff Dike <jdike@linux.intel.com>

There are still eight architectures that define the same values
in their private headers, those should probably get removed as well.

	Arnd
