Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab2GGOfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 10:35:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58619 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2GGOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 10:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <4FF6B232.4050502@cn.fujitsu.com>
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B232.4050502@cn.fujitsu.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sat, 7 Jul 2012 10:35:10 -0400
X-Google-Sender-Auth: SFG3tcznEUkboI7ZnolSEKVgWFQ
Message-ID: <CAP=VYLpAEHrNkzMVkvmRJNbx7SUKzWyN0V6NE8FgWNwuMw_hJQ@mail.gmail.com>
Subject: Re: [PATCH 2/7 v6] update linux headers
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 5:38 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

Minor nit, but adding text "for kvm" to the end of your subject can be
useful for people who are browsing short log of commits without
the context of the full patch series.   Since there were questions
about the what/why of the patch, perhaps a non-null long log would
have been a good addition too.

Thanks,
Paul.
--

> ---
>  linux-headers/asm-x86/kvm_para.h |    2 ++
>  linux-headers/linux/kvm_para.h   |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
