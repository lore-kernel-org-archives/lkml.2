Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab0JGHP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:15:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43293 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0JGHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tAFl3pK843CsdaxGezMcXCDu1rBycsQnTIOqZOfbKMyZPc8wk7nQAN+GmQa1q4T81c
         98Q4ArEaUGZ/rSXJuChvCXIbBKMC0UlmXpjEC2hEDZe6iUjDwQpzZXNv8CldLFgBjBp0
         V6N6tysAq3IGj3SnTNC22edc04SeAnlAsABOM=
Subject: Re: Build failure on CONFIG_DEBUG_FORCE_WEAK_PER_CPU?
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4CAB4EB3.50001@kernel.org>
References: <874od1w1ao.fsf@gmail.com>  <4CAAEF08.2090101@kernel.org>
	 <1286277111.1663.14.camel@leonhard>  <4CAB4EB3.50001@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 16:15:17 +0900
Message-ID: <1286435717.1709.5.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-05 (화), 18:13 +0200, Tejun Heo:
> and the same config builds just fine.  Can you please try newer
> compiler / linker?  The config option hasn't caused any trouble till
> now and allyesconfig is something which get regularly tested so I'm
> skeptical this is a wide spread problem.
> 
> Thanks.
> 

It was due to gold. When I built again after removing binutils-gold it's
just fine. Sorry for the noise.


-- 
Regards,
Namhyung Kim


