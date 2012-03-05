Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2CENFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:05:01 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22370 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008Ab2CENFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:05:00 -0500
Message-ID: <4F54B9D1.8080509@openvz.org>
Date: Mon, 05 Mar 2012 17:04:17 +0400
From: Kinsbursky Stanislav <skinsbursky@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "criu@openvz.org" <criu@openvz.org>
Subject: Re: [CRIU] [PATCH 0/2] IPC: message queue checkpoint support
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
In-Reply-To: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.
Are you going to take this patch set?

15.02.2012 20:54, Stanislav Kinsbursky пишет:
> This patch set conatins v2 of patch
> "IPC: message queue stealing feature introduced"
>
> The following series consists of:
>
> ---
>
> Stanislav Kinsbursky (2):
>        IPC: message queue receive cleanup
>        IPC: message queue stealing feature introduced
>
>
>   arch/tile/kernel/compat.c |   11 +-----
>   include/linux/compat.h    |    2 +
>   include/linux/msg.h       |   13 ++++++-
>   ipc/compat.c              |   62 ++++++++++++++++++++++++--------
>   ipc/msg.c                 |   86 +++++++++++++++++++++++++++++++++++----------
>   5 files changed, 126 insertions(+), 48 deletions(-)
>
> _______________________________________________
> CRIU mailing list
> CRIU@openvz.org
> https://openvz.org/mailman/listinfo/criu


-- 
Best regards,
Stanislav Kinsbursky

