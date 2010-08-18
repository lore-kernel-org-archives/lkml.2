Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0HRPTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:19:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41791 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0HRPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N4qS0sRzpchY+RziWCXDr4NGSmTCQyp+qnY03drqGy88xpLR9C+P/EtIY2d+LhjPte
         FO2iAkX+kW5vz6sVQnAEjFuS9JqFr64UurtPyp0r92fnVYigjSP7Xkm0UbfhrovRSz0k
         I2rGeuD4IhNSTuwckYrG0ReO1RWjevzkmvZ5U=
Date: Thu, 19 Aug 2010 00:18:57 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, swetland@google.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: android-kernel memory reclaim x20 boost?
Message-ID: <20100818151857.GA6188@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Android forks,

I could have a question in android kernel mailing list.
But I think many mm guys in linux-mm also might have a interest in it. 
So I send a question in linux-mm mailing list.

I saw the advertisement phrase in this[1]. 

"Kernel Memory Management Boost: Improved memory reclaim by up to 20x, 
which results in faster app switching and smoother performance 
on memory-constrained devices."

But I can't find any code for it in android kernel git tree.
If it's your private patch, could you explan what kinds of feature can enhance 
it by up to 20x?

If it is really good, we can merge it to mainline. 

[1] http://developer.android.com/sdk/android-2.2-highlights.html

-- 
Kind regards,
Minchan Kim
