Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1EWLHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:07:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40962 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1EWLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LkS1F9IrzUQOzB5eTgL2f82GuPxz/H8lo33vBkGx9aVrKwTpQjXSl33RTz5jkgpann
         /IsTydxj4QEnjbUuMGC0RwydqJ96YpJhwvtVfvkZZWG8ycOVbCiOzhth0sttNkxj+nU7
         PNLdSCM+riwVqw0yyrx3eIVcqYDXgx6UaNlt8=
Subject: Re: [PATCH 0/3] block: Per cpu merge stats and cfq fix
From: Namhyung Kim <namhyung@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dpshah@google.com
In-Reply-To: <20110521000650.GA8026@redhat.com>
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
	 <20110521000650.GA8026@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 20:07:20 +0900
Message-ID: <1306148840.1498.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-20 (금), 20:06 -0400, Vivek Goyal:
> On Fri, May 20, 2011 at 08:02:44PM -0400, Vivek Goyal wrote:
> > Hi Jens,
> > 
> > Here is the patch for making merge stats per cpu. While scanning the code
> > I also noticed that in one case I was not freeing up per cpu stats. First
> > patch fixes it. I also included Namhyung Kim's bio merge fix.
> > 
> > Thanks
> > Vivek
> > 
> > Vivek Goyal (3):
> >   cfq-iosched: Fix a memory leak of per cpu stats for root group
> >   cfq-iosched: Make IO merge related stats per cpu
> 
> Minor correction. Following patch author is Namhyung Kim.
> 
> Namhyung Kim(1)
> 
> >   block: call elv_bio_merged() when merged
> 
> Thanks
> Vivek
> 

Hi, Vivek. Thanks a lot for your work. :)


-- 
Regards,
Namhyung Kim


