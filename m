Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2CXEuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:50:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2CXEuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F6D50DD.4050306@zytor.com>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
	<201203240242.07724.trenn@suse.de>
	<4F6D2AF8.3070707@zytor.com>
	<201203240402.38749.trenn@suse.de>
	<4F6D50DD.4050306@zytor.com>
Date: Fri, 23 Mar 2012 21:50:12 -0700
X-Google-Sender-Auth: BTPeaBX6i-bJZrgJo9TqSKFaO5s
Message-ID: <CAE9FiQXvi-HPO+Ct=k0Ga_uaTrntJW=nh-VKnGbXaovFN=zDaQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 9:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Can this be implemented without using dynamic memory allocations?
>> If not, it's not suitable for early APCI overriding.
>
> Yes it can, as long as it is uncompressed.  It just becomes a matter of
> walking the cpio headers which is effectively a linked list.

During checking in reserve_inirtd() (BTW, the name of the function is outdated).
memblock is ready.
So dynamical memory allocation is there already.

also could put that headers in the tail, so old intird utilities could
work as before.

Yinghai
