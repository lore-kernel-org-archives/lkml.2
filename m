Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0I0VAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:00:48 -0400
Received: from xenotime.net ([72.52.115.56]:34398 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751806Ab0I0VAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:00:47 -0400
Message-ID: <47466.64.134.138.103.1285621238.squirrel@www.xenotime.net>
In-Reply-To: <20100927205442.GA18596@foursquare.net>
References: <20100924041410.GA18040@foursquare.net>
    <20100927205442.GA18596@foursquare.net>
Date: Mon, 27 Sep 2010 14:00:38 -0700 (PDT)
Subject: Re: ext3 filesystem corruption in user mode linux
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Chris Frey" <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, September 27, 2010 1:54 pm, Chris Frey wrote:
> On Fri, Sep 24, 2010 at 12:14:10AM -0400, Chris Frey wrote:
>
>> I'm not sure what the next debugging step should be.  I can test
>> different versions of UML kernels, or test patches, if more testing is
>> needed.
>
> Is this the wrong place to post about user mode linux?  I searched
> but I don't see a mailing list specific to ARCH=um.

I would expect here to be OK, but the MAINTAINERS file also lists
2 mailing lists and one web site:

L:	user-mode-linux-devel@lists.sourceforge.net
L:	user-mode-linux-user@lists.sourceforge.net
W:	http://user-mode-linux.sourceforge.net

-- 
~Randy

