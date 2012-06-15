Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2FOHkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:40:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49831 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2FOHkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:40:40 -0400
Message-ID: <1339746105.3321.15.camel@lappy>
Subject: Re: Early boot panic on machine with lots of memory
From: Sasha Levin <levinsasha928@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, avi@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>
Date: Fri, 15 Jun 2012 09:41:45 +0200
In-Reply-To: <CAE9FiQWP0vWQCUV3MjEhpCEwUHRG38VQwEeVEN_mKtDZYo8eOw@mail.gmail.com>
References: <1339623535.3321.4.camel@lappy>
	 <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1339667440.3321.7.camel@lappy>
	 <CAE9FiQVJ-q3gQxfBqfRnG+RvEh2bZ2-Ki=CRUATmCKjJp8MNuw@mail.gmail.com>
	 <1339709672.3321.11.camel@lappy>
	 <CAE9FiQVXxnjccSErjrZ9B-APGf5ZpKNovJwr5vNBMr1G2f8Y4Q@mail.gmail.com>
	 <1339721952.3321.14.camel@lappy>
	 <CAE9FiQWP0vWQCUV3MjEhpCEwUHRG38VQwEeVEN_mKtDZYo8eOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 19:21 -0700, Yinghai Lu wrote:
> On Thu, Jun 14, 2012 at 5:59 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > On Thu, 2012-06-14 at 16:57 -0700, Yinghai Lu wrote:
> >> can you please boot with "memtest" to see if there is any memory problem?
> >
> > The host got a memtest treatment, nothing found.
> 
> can you try to boot guest with memtest?

Tried that, memtest on guest didn't reveal anything but the guest
proceeded to crashing anyway.

