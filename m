Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0EOSs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:48:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:45113 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0EOSs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:48:28 -0400
Message-ID: <4BEEEC74.9060504@mev.co.uk>
Date: Sat, 15 May 2010 19:48:20 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alexander Kurz <linux@blala.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <ian.abbott@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped
 by bustype.
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com>
In-Reply-To: <20100514190142.GA2505@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, May 08, 2010 at 12:21:45PM +0400, Alexander Kurz wrote:
>> This is a new Kconfig and Makefikes for staging/comedi.
>> The drivers are sorted now alphabetically in sub-menus
>> depending on the bustype.
>> I did some basiy dependancy tests, but there still may
>> be a lot that I missed.
> Wow.  Is this something that we really want?  That's a lot of new
> Kconfig options, and while it seems like it makes sense, I would like to
> get the comedi developers opinion here.
> 
> Frank?  Ian?

I'm all for it and it was on my mental 'todo' list anyway!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
