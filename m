Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1EWNxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:53:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63397 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1EWNxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jgYQXPbWgQD9foCq5onN+LxrbgjdHXbx3uy0OeCdESGthNzFXjRUkQsR7CECQ7Dyqg
         EbwSkN3EJn8+tl18KnTy3vtdppNbwulJdklCyU+20imAG2+ukyv1MKkc/f4+EEcAgZUb
         eDeFQsqHYK5fWJVgFKVmN68d5Q1ZT23SK8JSc=
Subject: Re: [PATCH 0/3] block: Per cpu merge stats and cfq fix
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        dpshah@google.com
In-Reply-To: <4DDA151A.1020504@kernel.dk>
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
	 <20110521000650.GA8026@redhat.com>  <4DDA151A.1020504@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 22:53:35 +0900
Message-ID: <1306158815.1498.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-23 (월), 10:04 +0200, Jens Axboe:
> On 2011-05-21 02:06, Vivek Goyal wrote:
> > On Fri, May 20, 2011 at 08:02:44PM -0400, Vivek Goyal wrote:
> >> Hi Jens,
> >>
> >> Here is the patch for making merge stats per cpu. While scanning the code
> >> I also noticed that in one case I was not freeing up per cpu stats. First
> >> patch fixes it. I also included Namhyung Kim's bio merge fix.
> >>
> >> Thanks
> >> Vivek
> >>
> >> Vivek Goyal (3):
> >>   cfq-iosched: Fix a memory leak of per cpu stats for root group
> >>   cfq-iosched: Make IO merge related stats per cpu
> > 
> > Minor correction. Following patch author is Namhyung Kim.
> > 
> > Namhyung Kim(1)
> 
> Ugh, already merged it. I should have noticed that too, sorry about that
> Namhyung.
> 

Hi, Jens.
It's all right, I'm fine :)


-- 
Regards,
Namhyung Kim


