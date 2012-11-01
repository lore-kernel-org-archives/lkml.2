Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936141Ab2KAWPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:15:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57441 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190Ab2KAWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <11976302.Ya3MGGIAsU@vostro.rjw.lan>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
	<1748725.QBg5LLmPOx@vostro.rjw.lan>
	<CAE9FiQV0gAJabpcoSHhTYq19m-YmaC0O6HH_dFKXUTuvUMG4Fg@mail.gmail.com>
	<11976302.Ya3MGGIAsU@vostro.rjw.lan>
Date: Thu, 1 Nov 2012 15:15:31 -0700
X-Google-Sender-Auth: gyBe_DRvRij064zDjV2blNodxbU
Message-ID: <CAE9FiQVGPP3+97D2SatH_CBPBpqBZyCe7We=9=x5ZEq8_d0fWQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Improve container_notify_cb() to support container hot-remove.
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>, ZhangRui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, bhelgaas@google.com,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 2:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> oh, no, that commit should not be reverted. instead we should add some
>> comment for it...
>>
>> that mean : three path, will have three separated static lock dep key
>> from every INIT_WORK.
>
> I see.
>
> OK, I'll drop the patch removing it.
>
> What about the following comment:
>
> "To prevent lockdep from complaining unnecessarily, make sure that there
>  is a different static lockdep key created for each workqueue by using
>  INIT_WORK for each of them separately."
>
created ?

how about "defined" ?

or just remove  "created"
