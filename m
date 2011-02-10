Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1BJNxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:53:20 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:46961 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1BJNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:53:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xl11yH15VjZ6IfXWlR06zd/4uSGv9wCLKVMQDDnzyVsPZDLH0XMgsCtlO9UbvhcOZo
         s3pd5/bqzkqU54VXb+S3XMNak+JH3Rn0M6CyAzdMGN3TlzSmFCVrT1c5B18HG3CR+CuQ
         zwt+QLhVvZadcRTg5dIuOVQvz+RJzd0nja3ss=
Subject: Re: [RFC PATCH] mm: handle simple case in free_pcppages_bulk()
From: Namhyung Kim <namhyung@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimcLgsdEm6XKESc34Z=nsJkZqz8H1jR-ARZo_Gq@mail.gmail.com>
References: <1297338408-3590-1-git-send-email-namhyung@gmail.com>
	 <AANLkTikEigbPsNMqqkmixYbCfD7Dz12YMcW2+GZbhUQq@mail.gmail.com>
	 <1297343929.1449.3.camel@leonhard>
	 <AANLkTimcLgsdEm6XKESc34Z=nsJkZqz8H1jR-ARZo_Gq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 22:53:13 +0900
Message-ID: <1297345993.1449.10.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-02-10 (목), 22:38 +0900, Minchan Kim:
> > Hmm.. How about adding unlikely() then? Doesn't it help much here?
> 
> Yes. It would help but I am not sure how much it is.
> AFAIR, when Mel submit the patch, he tried to prove the effectiveness
> with some experiment and profiler.
> I think if you want it really, we might need some number.
> I am not sure it's worth.
> 

OK. Thanks for the comments. :)

And it would be really great if you (or somebody) told me how could I
make the numbers on my desktop.


-- 
Regards,
Namhyung Kim


