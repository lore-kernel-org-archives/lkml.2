Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0CPUEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:04:16 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60599 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab0CPUEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tbcc3JTFNiurLUPIaibGiiWJ1K0Eu7eFDGDrYr2Gy2z+K0lYKohSttGJXy1Fc6SGMj
         0UmLzNYt8AX7Z2LeDuyi3YRNR35+2zR/sgN/tpiB3c7E59U4gYSl93i8k/x8LPP9/t1E
         6xRkWzd5+AMafr1kI7p+bGFYsbeIB9cvhFd+k=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Etienne Basset <etienne.basset@numericable.fr>
Subject: Re: [2.6.34-rc1][libata] regression?
Date: Tue, 16 Mar 2010 21:04:04 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4B96C202.6050606@numericable.fr>
In-Reply-To: <4B96C202.6050606@numericable.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003162104.04163.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 9 marca 2010 o 22:47:46 Etienne Basset wrote:
> hello,
> 
> 
> with .34-rc1 i see some "stalls"; systems is frozen for say 30seconds, then
>  comes backs to life The only clue i have is strange ATA logs that I didn't
>  have before, see below. My disk may be dying, it's 6 years old, but i
>  shows the messages only in .34-rc1, never in .33 or .32
> 
I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15549
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
