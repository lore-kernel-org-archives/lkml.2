Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab1LOSFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:05:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60701 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1LOSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:05:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111215064444.GA14237@elte.hu>
References: <cover.1323803130.git.tony.luck@intel.com>
	<bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
	<20111214074749.GD25232@elte.hu>
	<20111214160702.GH23589@aftab>
	<20111214165459.GB32305@elte.hu>
	<0207C53569FE594381A4F2EB66570B2A019147EF6A@orsmsx508.amr.corp.intel.com>
	<20111215064444.GA14237@elte.hu>
Date: Thu, 15 Dec 2011 10:05:23 -0800
X-Google-Sender-Auth: qBPBRdEyVJChD-DAToJZ6nGKYnk
Message-ID: <CA+8MBbLRSnVFyxe=QcWyRdiMyU-MUYmtJXoZMfw8aC3tPj1BHw@mail.gmail.com>
Subject: Re: [PATCH 1/6] HWPOISON: clean up memory_failure() vs. __memory_failure()
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> The overall meaning is "land mine seen but not stepped on yet"
>
> Perfect message!

How about:

Uncorrected memory error in page 0x%lx ignored
Rebuild kernel with CONFIG_MEMORY_FAILURE=y for smarter handling

-Tony
