Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1BESfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:35:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57637 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1BESfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=aKH/+X5oGtvRAJfZfymWQ7mEHEEdfcMtfDccvIRgBA/o70yBNIZQFnCrKDbSvdXi+w
         q+ZiKGlEy+DrvSSR4AzcGRYEjA3veGFmIk1KlbPaIf1ylD+8wihzu6MikWZiAoOFk0ZF
         HcaZBfffisxKOwU/u61kI1DOg+Su1bXHMHCNM=
Message-ID: <4D4D9882.107@googlemail.com>
Date: Sat, 05 Feb 2011 19:35:46 +0100
From: "R. Herbst" <ruediger.herbst@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Sun GEM PPC32 Bug?
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>	<1296852667.2349.804.camel@pasglop> <20110204.145508.59670453.davem@davemloft.net>
In-Reply-To: <20110204.145508.59670453.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.02.2011 23:55, schrieb David Miller:
>
> I think we're simply not resetting enough when the RX FIFO overflow
> happens.
>
> Just for fun I checked the OpenBSD GEM driver to see what they do.
> When an overflow occurs, they bump the statistic, record the current
> read and write fifo pointer registers, and schedule a watchdog timer
> for 400ms into the future.
>
> If the watchdog timer sees that the RX FIFO overflow bit is still set
> in the RX status register, and the RX FIFO read and write pointers
> have not changed, it resets the entire chip.
>
> We unconditionally reset the RX MAC when an overflow occurs, that may
> simply not be enough to unwedge this thing.
>    
Is there a special Kernel parameter (sysctl.conf), that makes it 
possible to use the Network. So how it is now I can´t work with it. What 
can I do at the moment?
