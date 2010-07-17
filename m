Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0GQFxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 01:53:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45452 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0GQFxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 01:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=JxUrfv7gL/tmqqmpxITTlzlmaLB5Lo+zb0I7Sx9yebCBf26vfAMaaUyfF8yVr2pOfm
         XcZW7KkhiDN7OH9VjpHO5dezZ25vM5ESh2Pvztm45VOTXCWOhPgJFhqeafEpIb+GOAEN
         IUJZRD/bc4AgOEh5LB9CAXPt/CA6DbG1jJj9o=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: divya <dipraksh@linux.vnet.ibm.com>
Subject: Re: Badness with the kernel version 2.6.35-rc1-git1 running on P6 box
Date: Sat, 17 Jul 2010 07:52:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc5; KDE/4.4.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        sachinp@linux.vnet.ibm.com, benh@kernel.crashing.org
References: <4C401D56.3070108@linux.vnet.ibm.com>
In-Reply-To: <4C401D56.3070108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007170752.53933.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 16 lipca 2010 o 10:50:30 divya wrote:
> Hi ,
> 
> With the latest kernel version 2.6.35-rc5-git1(2f7989efd4398) running on
> power(p6) box came across the following call trace
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16406
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
