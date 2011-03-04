Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab1CDEA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:00:59 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36098 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab1CDEA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CuzmevW8CpsNxkGuU71KWnApHNGbAQEooRibFHsWUysa3zgJFUhqaGTQi0jkdk6PyI
         NaA5k/n9Bgr1f2g9WOH754xr9qlzwdzqzY55Voq/j5HUXnQ1RRrwhmQNKgnSfm45vUy7
         Ufdpcna9jX9U4SrltX4CNF/YV8UaxrYbMIssw=
Subject: Re: [PATCH v2 -tip] x86: correct stack dump info when
 CONFIG_FRAME_POINTER=y
From: Namhyung Kim <namhyung@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110303164723.GA1807@nowhere>
References: <1299086232-29639-1-git-send-email-namhyung@gmail.com>
	 <1299151037-5881-1-git-send-email-namhyung@gmail.com>
	 <20110303164723.GA1807@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 13:00:52 +0900
Message-ID: <1299211252.1444.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-03-03 (목), 17:47 +0100, Frederic Weisbecker:
> In fact if a caller of dump_trace() passes a stack, it should pass a
> frame pointer as well.
> 
> That means we need to revert 9c0729dc8062bed96189bd14ac6d4920f3958743
> ("x86: Eliminate bp argument from the stack tracing routines").
> It would be nice to keep the unified stack_frame() helper out of the revert though, 
> 
> Would you like to do it?
> 
> Thanks.

Of course :) Will send v3.

Thanks.


-- 
Regards,
Namhyung Kim


