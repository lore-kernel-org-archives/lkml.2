Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1IYJNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 05:13:32 -0400
Received: from home.kolivas.org ([59.167.196.135]:39078 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751681Ab1IYJNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 05:13:31 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: BFS cpu scheduler and skip list implementation
Date: Sun, 25 Sep 2011 19:13:28 +1000
User-Agent: KMail/1.13.6 (Linux/3.0.0-ck1; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201109240945.58879.kernel@kolivas.org> <20110925090417.GA19813@fancy-poultry.org>
In-Reply-To: <20110925090417.GA19813@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109251913.28120.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Sep 2011 19:04:17 Heinz Diehl wrote:
> On 24.09.2011, Con Kolivas wrote:
> > Try it out, see what you think.
> 
> Your patch applies cleanly to 3.0.4 vanilla, but compilation fails:
> 
> [....]
> /usr/src/linux-3.0.4/usr/include/linux/sched.h:1504: userspace cannot

I'm guessing you did not configure in the BFS CPU scheduler, which is pretty 
much mandatory with this patch.

Regards,
Con

-- 
-ck
