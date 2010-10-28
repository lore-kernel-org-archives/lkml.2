Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0J1X3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:29:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63289 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771Ab0J1X33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u/Uz4QEzd6Oc3rQrALlwnixpuEx3E/etezKKlgwtyoBUa8jqbA0edkHYi0uz1jAiOi
         S4ZJS9ZeWvLJos6LCGSAGjjUK8M4vhSqCN01Dixoz5I60bhLIhATeal899CuA5Vuomcu
         165SVsqskzbPG9O5VDy+2SQr/SgaxC8QZ/PYw=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=VnTkuyYht8D+2MPO1d4mXR1ah-0aQeAjZsTaq@mail.gmail.com>
References: <20101028191523.GA14972@google.com>
	<20101028131029.ee0aadc0.akpm@linux-foundation.org>
	<20101028220331.GZ26494@google.com>
	<AANLkTi=VnTkuyYht8D+2MPO1d4mXR1ah-0aQeAjZsTaq@mail.gmail.com>
Date: Fri, 29 Oct 2010 08:29:29 +0900
Message-ID: <AANLkTi=f5-4rOcf8WwSnM4bwV-xBxQ_G++ZdYj_GL1ii@mail.gmail.com>
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for
 protecting the working set
From: Minchan Kim <minchan.kim@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 8:28 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> I think this feature that "System response time doesn't allow but OOM allow".
I think we _need_ this feature that "System response time doesn't
allow but OOM allow".

-- 
Kind regards,
Minchan Kim
