Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2DPPyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:54:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48835 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2DPPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:54:05 -0400
Date: Tue, 17 Apr 2012 00:54:01 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: MMU: return bool in __rmap_write_protect
Message-Id: <20120417005401.0b9ae3a75fdc73a39f154c30@gmail.com>
In-Reply-To: <4F8C2C90.6030703@redhat.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FBC1.5010907@linux.vnet.ibm.com>
	<20120414110031.38450bebfe712215f01d529f@gmail.com>
	<4F8AB02A.9020601@redhat.com>
	<20120416231455.f978b3ac9fb995cfce2853ae@gmail.com>
	<4F8C2C90.6030703@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 17:28:32 +0300
Avi Kivity <avi@redhat.com> wrote:

> > But the real question is whether there is any point in re-writing completely
> > correct C code: there are tons of int like this in the kernel code.
> >
> > __rmap_write_protect() was introduced recently, so if this conversion is
> > really worthwhile, I should have been told to use bool at that time, no?
> 
> It's up to developer and maintainer preference.  I like bool since it
> documents the usage and is safer, but sometimes I miss it on review.

OK.

Thank you for your explanation!

	Takuya
