Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2GJTp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:45:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60461 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2GJTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:45:58 -0400
MIME-Version: 1.0
In-Reply-To: <CF1C132D-2873-408A-BCC9-B9F57BE6EDDB@linuxfoundation.org>
References: <20120710111756.GA11351@localhost>
	<CF1C132D-2873-408A-BCC9-B9F57BE6EDDB@linuxfoundation.org>
Date: Tue, 10 Jul 2012 22:45:57 +0300
X-Google-Sender-Auth: jdpj8DDeZ4wAXIQOckp7WbZrzXk
Message-ID: <CAOJsxLG7fWuHeh-KXzG1PHwZRWztQQYvmxgn_97aYBCtqrLWug@mail.gmail.com>
Subject: Re: linux-next: Early crashed kernel on CONFIG_SLOB
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <christoph@linuxfoundation.org>
Cc: "wfg@linux.intel.com" <wfg@linux.intel.com>,
        Christoph Lameter <cl@linux.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 10, 2012, at 6:17, wfg@linux.intel.com wrote:
>> This commit crashes the kernel w/o any dmesg output (the attached one
>> is created by the script as a summary for that run). This is very
>> reproducible in kvm for the attached config.
>>
>>        commit 3b0efdfa1e719303536c04d9abca43abeb40f80a
>>        Author: Christoph Lameter <cl@linux.com>
>>        Date:   Wed Jun 13 10:24:57 2012 -0500
>>
>>            mm, sl[aou]b: Extract common fields from struct kmem_cache

On Tue, Jul 10, 2012 at 9:37 PM, Christoph Lameter
<christoph@linuxfoundation.org> wrote:
> I sent a patch yesterday (or was it friday) to fix the issue. Sorry @airport right now.

Which patch is that? I can't seem to find it.
