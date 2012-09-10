Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2IJSER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab2IJSEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:04:15 -0400
Message-ID: <504E2B98.3010007@redhat.com>
Date: Mon, 10 Sep 2012 14:04:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Frank Swiderski <fes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
References: <1340742778-11282-1-git-send-email-fes@google.com> <20120910090521.GB18544@redhat.com> <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
In-Reply-To: <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 01:37 PM, Mike Waychison wrote:
> On Mon, Sep 10, 2012 at 5:05 AM, Michael S. Tsirkin <mst@redhat.com> wrote:

>> Also can you pls answer Avi's question?
>> How is overcommit managed?
>
> Overcommit in our deployments is managed using memory cgroups on the
> host.  This allows us to have very directed policies as to how
> competing VMs on a host may overcommit.

How do your memory cgroups lead to guests inflating their balloons?

-- 
All rights reversed
