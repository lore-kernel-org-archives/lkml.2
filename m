Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2DWJyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:54:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51430 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2DWJyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120330234306.GC21328@kroah.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
 <20120330204235.GA883@kroah.com> <alpine.LFD.2.02.1203302247130.2542@ionos>
 <201203302105.52987.arnd@arndb.de> <20120330211744.GA16314@kroah.com>
 <CA+1xoqeWLrU46gBJVY1j1S2_wNkvCvG-CdK0DKx5dgWR=EmU+Q@mail.gmail.com> <20120330234306.GC21328@kroah.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 23 Apr 2012 11:54:02 +0200
Message-ID: <CA+1xoqdMX8FiDNrwJEsKEByre0PWFBpc+DQf7Xx-hS_Vkj6Ezg@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        viro@zeniv.linux.org.uk, davej@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 1:43 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Ok, care to update this patch with a max size?

Are there any objections to using PAGE_SIZE? If not, I'll send a revised patch.
