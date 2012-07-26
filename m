Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2GZJVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:21:03 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:45211 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2GZJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:21:00 -0400
Date: Thu, 26 Jul 2012 18:20:33 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: remove dummy pages
Message-Id: <20120726182033.e127e9e6.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <5011062F.3080505@redhat.com>
References: <5010C008.4030304@linux.vnet.ibm.com>
	<5010C083.30102@linux.vnet.ibm.com>
	<5011062F.3080505@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012 11:56:15 +0300
Avi Kivity <avi@redhat.com> wrote:

> Since my comments are better done as a separate patch, I applied all
> three patches.  Thanks!

Is this patch really safe for all architectures?

IS_ERR_VALUE() casts -MAX_ERRNO to unsigned long and then does comparison.
Isn't it possible to conflict with valid pfns?

What are the underlying assumptions?

	Takuya
