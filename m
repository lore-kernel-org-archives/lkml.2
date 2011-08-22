Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1HVInB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1HVIm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:42:56 -0400
Message-ID: <4E521688.1000701@redhat.com>
Date: Mon, 22 Aug 2011 16:42:48 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月20日 08:37, Arnaud Lacombe 写道:
> Hi folks,
>
> The attached patch modify Kbuild to allow to directly re-use code in multiple
> directory without having to go through a copy. Technically, it changes Kbuild to
> use by default the VPATH feature of GNU make and provides accessors for Makefile
> to change it indirectly.
...
>
> With the attached patch, we would do:
>
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> vpath-y += $(srctree)/arch/foo/lib
>
> and let GNU make do the job.

Just note that don't forget to update Documentation/kbuild/makefiles.txt. ;)

Thanks.
