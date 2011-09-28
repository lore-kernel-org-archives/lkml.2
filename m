Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1I1IBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:01:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1I1IBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:01:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=yoc1sEbbnXi4hc5qHbaCmsFgVB+qUje+lw5d3CSLhtAve5tDf5X40qkxnRrkmfqQN
	uhD2ILoCTE/USVbRBZmYA==
MIME-Version: 1.0
In-Reply-To: <1317195706.5781.1.camel@twins>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-5-git-send-email-walken@google.com>
	<1317195706.5781.1.camel@twins>
Date: Wed, 28 Sep 2011 01:01:29 -0700
Message-ID: <CANN689Gtv2B1j6Z5wTk1ysne+XVV8VfU+9jepY1RV4r=B7V_Zw@mail.gmail.com>
Subject: Re: [PATCH 4/9] kstaled: minimalistic implementation.
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
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

On Wed, Sep 28, 2011 at 12:41 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-09-27 at 17:49 -0700, Michel Lespinasse wrote:
>> +static int kstaled(void *dummy)
>> +{
>> +       while (1) {
>
>> +       }
>> +
>> +       BUG();
>> +       return 0;       /* NOT REACHED */
>> +}
>
> So if you build with this junk (as I presume distro's will), there is no
> way to disable it?

There will be a thread, and it'll block in wait_event_interruptible()
until a positive value is written into
/sys/kernel/mm/kstaled/scan_seconds

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
