Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2JUAS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 20:18:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58668 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab2JUAS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 20:18:56 -0400
Message-ID: <50833F30.4020802@ti.com>
Date: Sat, 20 Oct 2012 17:17:52 -0700
From: Tom Rini <trini@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Shin, Jacob" <Jacob.Shin@amd.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur>
In-Reply-To: <d556fc0f-da5d-4531-b331-6dc086461f34@blur>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/12 17:11, Shin, Jacob wrote:
> Hi could you please attach the dmesg output? Before rc2 is fine as well.
> I would like to see the E820 table. Thank you,

dmesg is quite long so I've put it on pastebin: http://pastebin.com/4eSPEAvB

-- 
Tom
