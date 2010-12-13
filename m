Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0LMI5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:57:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35427 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0LMI5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:57:34 -0500
Message-ID: <4e0d4bb9da2d1b0e1196ae2af4c2ddb8.squirrel@www.firstfloor.org>
In-Reply-To: <E87738D94A6AD54789B5B8D1BAEB06CC700C2347FF@azsmsx503.amr.corp.intel.com>
References: <201012131244.547034648@firstfloor.org>
    <20101212234751.76302B27BF@basil.firstfloor.org>
    <E87738D94A6AD54789B5B8D1BAEB06CC700C2347FF@azsmsx503.amr.corp.intel.com>
Date: Mon, 13 Dec 2010 09:57:31 +0100
Subject: RE: [PATCH] [167/223] ACPI: debugfs custom_method open to non-root
From: "Andi Kleen" <andi@firstfloor.org>
To: "Brown, Len" <len.brown@intel.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "davej@redhat.com" <davej@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 2.6.35-longterm review patch.  If anyone has any objections, please let
>> me know.
>
> is -longterm something that happens after -stable runs out of gas?

Yes (but not for all kernels)

> Note that this particular patch applies back to 2.6.33.

Paul G. could consider it for his 2.6.34 then.
-Andi

