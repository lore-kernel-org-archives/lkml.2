Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1AaLgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:36:51 -0500
Received: from www.tglx.de ([62.245.132.106]:52469 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab1AaLgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:36:51 -0500
Date: Mon, 31 Jan 2011 12:36:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, yong.zhang0@gmail.com, hch@infradead.org
Subject: Re: [PATCH v2 02/20] move get_jiffies_64 to kernel/time/jiffies.c
In-Reply-To: <20110127145900.23248.73352.stgit@localhost>
Message-ID: <alpine.LFD.2.00.1101311231270.31804@localhost6.localdomain6>
References: <20110127145741.23248.68098.stgit@localhost> <20110127145900.23248.73352.stgit@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-2085710590-1296473796=:31804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-2085710590-1296473796=:31804
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Jan 2011, Torben Hohn wrote:

> in order to make the xtime_lock local to kernel/time
> all users of this lock need to be moved there.

Did you even compile that ?

kernel/time/jiffies.c:83: warning: data definition has no type or storage class
kernel/time/jiffies.c:83: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
kernel/time/jiffies.c:83: warning: parameter names (without types) in function declaration

That misses an #include <linux/module.h>

I fixed that up. Please be more careful next time.

Thanks,

	tglx
---1463795968-2085710590-1296473796=:31804--
