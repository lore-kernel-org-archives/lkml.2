Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab0HTHRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:17:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44945 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0HTHRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vk261Wrqlq8D77fttrPumO3HVi8qqTJcCYkcdv4NmuxrVQBpiktrh7bb2eximFG0eM
         FYTc/DV81MUChP1QPlZmt3oul3/hWLzjJlLQVBwaZzg1DkZYB62RTEi1GTtV1mjf+103
         /QEcSQJuikCA5ZcxrJDTaJHrwqJ/bHakZ1KrQ=
MIME-Version: 1.0
In-Reply-To: <20100819144921.40d6765f.akpm@linux-foundation.org>
References: <1282138278-22304-1-git-send-email-ext-andriy.shevchenko@nokia.com>
	<20100819144921.40d6765f.akpm@linux-foundation.org>
Date: Fri, 20 Aug 2010 10:17:20 +0300
Message-ID: <AANLkTi=ktmW4d1VQ2RBnVyJAQkpfRRXzrObkpAY0V0yw@mail.gmail.com>
Subject: Re: [PATCH] mmc: make dev_to_mmc_card() macro public
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 12:49 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> nit: generally, subsystem-specific identifiers should use their
> subsystem's identifier as a prefix.  So a better name for
> dev_to_mmc_card() would be mmc_dev_to_card().
Sounds reasonable.
Would you like to get new version of patch or fix against patch?

-- 
With Best Regards,
Andy Shevchenko
