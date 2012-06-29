Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2F2Bqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:46:45 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:53905 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2F2Bqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:46:43 -0400
Date: Fri, 29 Jun 2012 10:46:29 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in
 kvm_handle_hva_range()
Message-Id: <20120629104629.b369cd40.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4FEC9A2B.6000104@redhat.com>
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp>
	<20120628110235.7410445e.yoshikawa.takuya@oss.ntt.co.jp>
	<4FEC9A2B.6000104@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 20:53:47 +0300
Avi Kivity <avi@redhat.com> wrote:

> > Note: in the new code we could not use trace_kvm_age_page(), so we just
> > dropped the point from kvm_handle_hva_range().
> > 
> 
> Can't it be pushed to handler()?

Yes, but it will be changed to print rmap, not hva and gfn.
I will do in the next version.

Thanks,
	Takuya
