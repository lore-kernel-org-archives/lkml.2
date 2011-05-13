Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1EMGQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:16:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1EMGQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I2Y53i4RWeGTdf9j9e6NXVKMUiWov/L7XPTvaaUPZnKPAjsy4hY+sze/6+p4ZlaiMQ
         bUZVnUb+hp9IbnmzpJUfowk3bHW2bVifxj1qqtEUOGfqpjfeV5wojqDcZkRiwC8nSNEH
         cxLoPpwHhg2zPi8OYu8DvZxw+rmkF5MlGxz6E=
MIME-Version: 1.0
In-Reply-To: <1305230652.2575.72.camel@mulgrave.site>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	<1305127773-10570-4-git-send-email-mgorman@suse.de>
	<alpine.DEB.2.00.1105120942050.24560@router.home>
	<1305213359.2575.46.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121024350.26013@router.home>
	<1305214993.2575.50.camel@mulgrave.site>
	<1305215742.27848.40.camel@jaguar>
	<1305225467.2575.66.camel@mulgrave.site>
	<1305229447.2575.71.camel@mulgrave.site>
	<1305230652.2575.72.camel@mulgrave.site>
Date: Fri, 13 May 2011 09:16:24 +0300
X-Google-Sender-Auth: L9AnrZE6EjIqr59SWXbV7dh1L_s
Message-ID: <BANLkTindTdL9a4VxZk_AXrWLQf6QWqjz5g@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: Pekka Enberg <penberg@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 12, 2011 at 11:04 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Confirmed, I'm afraid ... I can trigger the problem with all three
> patches under PREEMPT.  It's not a hang this time, it's just kswapd
> taking 100% system time on 1 CPU and it won't calm down after I unload
> the system.

OK, that's good to know. I'd still like to take patches 1-2, though. Mel?

                        Pekka
