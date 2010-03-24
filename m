Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab0CXUyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:54:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44554 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0CXUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QehNP8+JSNk6A+45bYeAddmjB63uvTv7O66Ftt3O9vEAwsvOaNaotaxLymHXlErmt7
         jarNm4cXlmZhJxh1f28RVUlSaRsRPPLwWv91urLd51GT+dblLKBZw266CStQ7opdXq60
         3v2SZhi5Tm5lUeN3p4Qz4YxiqnvradcZSdg4Y=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [BUG] percpu misaligned allocation
Date: Wed, 24 Mar 2010 21:54:12 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20100318044930.GC5045@nowhere>
In-Reply-To: <20100318044930.GC5045@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003242154.12214.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 18 marca 2010 o 05:49:33 Frederic Weisbecker wrote:
> Hi,
> 
> While using the lock events through perf in a sparc box, I can see
> the following message repeated many times:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15624
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
