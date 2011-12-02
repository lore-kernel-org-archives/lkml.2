Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1LBFqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:46:33 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33311 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1LBFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:46:31 -0500
Message-ID: <1322804776.3619.3.camel@lappy>
Subject: Re: [PATCH] KVM: Veirfy memory slot only for readability
From: Sasha Levin <levinsasha928@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Date: Fri, 02 Dec 2011 07:46:16 +0200
In-Reply-To: <4ED84314.5070107@oss.ntt.co.jp>
References: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>
	 <4ED826CA.5030502@oss.ntt.co.jp> <4ED84314.5070107@oss.ntt.co.jp>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 12:16 +0900, Takuya Yoshikawa wrote:
> (2011/12/02 10:15), Takuya Yoshikawa wrote:
> > (2011/12/02 4:42), Sasha Levin wrote:
> >> It's enough for memory slot to be readable, as the comment above the check
> >> states.
> >>
> >> A user should be able to create read-only memory slot.
> 
> Note: at that time, it looked to me that the API did not allow me to know
> which type was being registered.

Which code exactly assumes that all memory slots are writable?

> Do you want to create read only memory slots for kvm tool?

What KVM tool currently does is copy the kernel into guest memory and
run it from there. An idea raised recently was instead of copying it we
should mmap it into the memory to reduce footprint.

This is why I'm looking into adding a read only memory slot. The KVM
code doesn't have to know it's read only.

-- 

Sasha.

