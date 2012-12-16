Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2LPSH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 13:07:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46461 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2LPSH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 13:07:28 -0500
MIME-Version: 1.0
In-Reply-To: <50CE0C82.20708@itwm.fraunhofer.de>
References: <50CB3EAB.309@itwm.fraunhofer.de>
	<CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
	<CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com>
	<50CE0C82.20708@itwm.fraunhofer.de>
Date: Sun, 16 Dec 2012 10:07:27 -0800
X-Google-Sender-Auth: 2T17rdv6iLaj83lzT38pxq0NGWY
Message-ID: <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
Subject: Re: [regression] 3.7 ends in APIC panic
From: Yinghai Lu <yinghai@kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 10:01 AM, Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:
>> can you post your .config for v3.7 ?
>>
>> wonder if you have x2apic in .config
>
> Which setting is it? Config is attached.

your config does not have

CONFIG_X86_X2APIC=y

set.

please enable that.

your BIOS pre-enable x2apic somehow, so you must have x2apic enabled in kernel.

it x2apic really can not be re-enabled by kernel, kernel would disable
x2apic automatically.

Thanks

Yinghai
