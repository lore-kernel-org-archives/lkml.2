Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0FNPK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:10:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48400 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0FNPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eb38Err9Eg3WdbV5m13QE86A17I7eUhcGzTvc8pQrJ/13ztR2mlJvJfLRAHQEX0Ggi
         bc+62p6W+I2gyPF1G39wbQZUfsbQ3Q9789pCc8n7gi4rC3rLv6lkgp1sVqWRgfgbCUxs
         un+BWZWjUuJ8gJ+sqNsMz/HSiGileOmz3mPhk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: Panic on boot on today's tip/master
Date: Mon, 14 Jun 2010 17:10:47 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc3; KDE/4.3.4; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <20100610112839.GK5878@linux.vnet.ibm.com>
In-Reply-To: <20100610112839.GK5878@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141710.47568.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 10 czerwca 2010 o 13:28:39 Srikar Dronamraju wrote:
> When I updated my tip/master and rebooted into it, I am seeing a panic on
>  boot.
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16208
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
