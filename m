Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1I2UcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:32:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1I2UcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:32:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xw6qHde5KNTtQyYgB8AS3Lu4IkZGdObGpXbpOqfSLoTg2ZKBSwkqNnAAFv/Sg3Ye4
	VovFADC+D/os66UyroRLQ==
MIME-Version: 1.0
In-Reply-To: <20110929164319.GA3509@mgebm.net>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<20110929164319.GA3509@mgebm.net>
Date: Thu, 29 Sep 2011 13:25:00 -0700
Message-ID: <CANN689H1G-USQYQrOTb47Hrc7KMjLdxkppYCDKsTUy5WhuRs7w@mail.gmail.com>
Subject: Re: [PATCH 0/9] V2: idle page tracking / working set estimation
From: Michel Lespinasse <walken@google.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 9:43 AM, Eric B Munson <emunson@mgebm.net> wrote:
> I have been trying to test these patches since yesterday afternoon.  When my
> machine is idle, they behave fine.  I started looking at performance to make
> sure they were a big regression by testing kernel builds with the scanner
> disabled, and then enabled (set to 120 seconds).  The scanner disabled builds
> work fine, but with the scanner enabled the second time I build my kernel hangs
> my machine every time.  Unfortunately, I do not have any more information than
> that for you at the moment.  My next step is to try the same tests in qemu to
> see if I can get more state information when the kernel hangs.

Could you please send me your .config file ? Also, did you apply the
patches on top of straight v3.0 and what is your machine like ?

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
