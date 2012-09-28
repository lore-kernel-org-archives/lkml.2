Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab2I1WbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:31:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51223 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2I1WbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <50651D65.5080400@jp.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
 <1348724705-23779-2-git-send-email-wency@cn.fujitsu.com> <CAEkdkmVW5wwG4_cy0yHFNVmk2bzAqzo2adRsMn1yHOW9Ex98_g@mail.gmail.com>
 <5064EE3F.3080606@jp.fujitsu.com> <CAHGf_=pDn852sRadnXQMWx3rOTxGLy7876pxk1Ww4oJtkBAZbQ@mail.gmail.com>
 <50651D65.5080400@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 28 Sep 2012 18:30:45 -0400
X-Google-Sender-Auth: GbZNH_c-YYQHcmO4crT6tnBkwjw
Message-ID: <CAHGf_=pSEptM-F4+KefqyPeefzH1aC+rkJ13Cg_ssRvA1UyqLw@mail.gmail.com>
Subject: Re: [PATCH 1/4] memory-hotplug: add memory_block_release
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>, wency@cn.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is not correct. The kobject_put() is prepared against find_memory_block()
> in remove_memory_block() since kobject->kref is incremented in it.
> So release_memory_block() is called by device_unregister() correctly as
> follows:

Ok. Looks good then.
Please rewrite the description more kindly at next spin. Current one
is really really bad.
