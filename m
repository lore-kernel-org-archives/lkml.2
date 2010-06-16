Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0FPBY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 21:24:57 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:17976 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0FPBY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 21:24:56 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 21:24:55 EDT
Date: Tue, 15 Jun 2010 20:15:29 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
Message-ID: <20100616011529.GA1391790@hiwaay.net>
References: <eVJGi-4rh-13@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615202924.24446d28@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Alan Cox  <alan@lxorguk.ukuu.org.uk> said:
>> +#define EXTPROC	0x10000000
>
>For Alpha this value should match OSF if possible.

Since I'm reading this on an Alpha right now, I figured I'd do my bit to
help out.  As far as I can tell, Tru64 5.1B doesn't define this, nor
does the above value match any of the Tru64-defined local flags.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
