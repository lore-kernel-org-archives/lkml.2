Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2FOCVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 22:21:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52338 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2FOCVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 22:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <1339721952.3321.14.camel@lappy>
References: <1339623535.3321.4.camel@lappy>
	<20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	<1339667440.3321.7.camel@lappy>
	<CAE9FiQVJ-q3gQxfBqfRnG+RvEh2bZ2-Ki=CRUATmCKjJp8MNuw@mail.gmail.com>
	<1339709672.3321.11.camel@lappy>
	<CAE9FiQVXxnjccSErjrZ9B-APGf5ZpKNovJwr5vNBMr1G2f8Y4Q@mail.gmail.com>
	<1339721952.3321.14.camel@lappy>
Date: Thu, 14 Jun 2012 19:21:33 -0700
X-Google-Sender-Auth: CaMa9ikTqDVGVauxKs4almhM6dA
Message-ID: <CAE9FiQWP0vWQCUV3MjEhpCEwUHRG38VQwEeVEN_mKtDZYo8eOw@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, avi@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 5:59 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2012-06-14 at 16:57 -0700, Yinghai Lu wrote:
>> can you please boot with "memtest" to see if there is any memory problem?
>
> The host got a memtest treatment, nothing found.

can you try to boot guest with memtest?

Thanks

Yinghai
