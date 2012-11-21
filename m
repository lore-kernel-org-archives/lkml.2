Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2KUUPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:15:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48736 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab2KUUPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:15:30 -0500
MIME-Version: 1.0
In-Reply-To: <50AD307C.6060008@zytor.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-2-git-send-email-yinghai@kernel.org>
	<50AD0E22.3020807@zytor.com>
	<CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
	<50AD307C.6060008@zytor.com>
Date: Wed, 21 Nov 2012 12:15:28 -0800
X-Google-Sender-Auth: 40TRfmeWLUAMZbwOOZRDjQDjyMQ
Message-ID: <CAE9FiQUaajsWe3854xxUOyPEZ7Dbt3GE0VWs8KvQbtqVrOXQdw@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:50 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> The comment is just plain wrong.  It assumes you're loading an ELF file,
> whereas in practice that is rarely true.
>
> This does explain why the poor ABI, though.  A jump table at the
> beginning would have been a lot cleaner.

Can you please have patch to update the comments and point to the API there ?

Thanks

Yinghai
