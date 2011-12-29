Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1L2ObV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 09:31:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1L2ObT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 09:31:19 -0500
Message-ID: <4EFC79AD.3090104@redhat.com>
Date: Thu, 29 Dec 2011 16:31:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, gleb@redhat.com,
        mtosatti@redhat.com, xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1324975139-8836-1-git-send-email-kernelfans@gmail.com> <4EF9AA59.7050003@oss.ntt.co.jp> <CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com> <4EFAE705.6070202@redhat.com> <CAFgQCTtFFOYY09Edg_ibNTRYfxHh1HRjqgpRyBy7jUZYJgEJxA@mail.gmail.com>
In-Reply-To: <CAFgQCTtFFOYY09Edg_ibNTRYfxHh1HRjqgpRyBy7jUZYJgEJxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 04:03 PM, Liu ping fan wrote:
> > Why do we want an independent grace period, is hotunplugging a vcpu that
> > much different from hotunplugging memory?
> >
> I thought that if less readers on the same srcu lock, then
> synchronize_srcu_expedited() may success to return more quickly.

It would be good to measure it, otherwise it's premature optimization.

-- 
error compiling committee.c: too many arguments to function

