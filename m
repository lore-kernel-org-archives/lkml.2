Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2FOKZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:25:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:41558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2FOKZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:25:18 -0400
Message-ID: <1339755916.2559.53.camel@twins>
Subject: Re: Need of automatic scripts for beginners
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Anil Nair <anilcoll90@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Date: Fri, 15 Jun 2012 12:25:16 +0200
In-Reply-To: <20120615034410.GA6380@kroah.com>
References: <CAHkwNTnsVW6psWORXAEWVeQ+-ZQauY43SbE0P+be3FQD61PaOA@mail.gmail.com>
	 <20120615034410.GA6380@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 20:44 -0700, Greg KH wrote:
> If your distro is set up properly, that should be all that you need to
> do. 

Last time I tried that it didn't actually work due to a lot
of /sbin/installkernel scrips omitting to generate an initrd or whatnot.
