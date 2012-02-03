Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2BCH02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:26:28 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:35108 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2BCH0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:26:24 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AptOAGmLK09V5qrvPGdsb2JhbABDrxgZAQEBAR4ZDSWBcwEFOhwjEAgDRhQlCgYUiBIGuE8TizoCAgkFDAcGAQQBAQkEFAcEDwMDAYJ1AgsDBBoEAoEJEoJWYwSVIoVnjHE
X-IronPort-AV: E=Sophos;i="4.73,350,1325458800"; 
   d="scan'208";a="262939926"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 3 Feb 2012 08:27:25 +0100
To: Chase Douglas <chasedouglas@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
Message-ID: <20120203072725.GA6914@polaris.bitmath.org>
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
 <4F2B24AC.1020408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2B24AC.1020408@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

> > +#define INPUT_MT_REQUEST(num_slots)					\
> > +	{								\
> > +		__u32 code;						\
> > +		__s32 values[num_slots];				\
> 
> I think this assumes a userspace C compiler that can handle variable
> length arrays. This would require only compiling in C source code at the
> C99 standard or later. It looks like C++ doesn't even allow variable
> length arrays, though gcc handles it. According to:
> 
> http://www.cplusplus.com/forum/beginner/1601/
> 
> it looks like Borland c++ compilers may not be able to compile this :(.

This is resolved on the preprocessor level, so C99 or not does not
enter the problem. Compile-time constant, as you can see in the code
example in the patch summary.

Thanks,
Henrik
