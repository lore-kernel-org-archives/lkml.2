Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2CLMFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2CLMFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:05:19 -0400
Message-ID: <4F5DE679.2050003@redhat.com>
Date: Mon, 12 Mar 2012 14:05:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less get_dirty_log()
References: <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp> <20120303142148.2689454b30dc86d84c4a19f5@gmail.com> <20120306111540.GA29914@amt.cnet> <20120306234317.2817d2071038d11ab3831c82@gmail.com> <20120306150104.GA3041@amt.cnet> <20120307002317.d8682de9c6ccd6af8ccac467@gmail.com> <20120306152850.GB3353@amt.cnet> <20120307170745.3147f776.yoshikawa.takuya@oss.ntt.co.jp> <20120307232520.GB29570@amt.cnet> <20120308103545.24b81093.yoshikawa.takuya@oss.ntt.co.jp> <20120309000835.GA25838@amt.cnet>
In-Reply-To: <20120309000835.GA25838@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 02:08 AM, Marcelo Tosatti wrote:
> > So, it would be helpful if you can apply the patch series and I can work
> > on top of that: although I cannot use servers with 100GB memory now,
> > migrating a guest with 16GB memory or so may be possible later: I need
> > to reserve servers for that.
>
> Makes sense.

To me too.

> It looks good to me, Avi can you review & ack please?

Patchset is fine from my point of view, I think it's a great improvement.

-- 
error compiling committee.c: too many arguments to function

