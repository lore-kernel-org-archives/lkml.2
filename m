Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0DISZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 14:25:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0DISZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 14:25:46 -0400
Message-ID: <4BBF70BC.3080809@zytor.com>
Date: Fri, 09 Apr 2010 11:23:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>,
       Guenter Roeck <guenter.roeck@ericsson.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio> <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com>
In-Reply-To: <4BBF626A.3060800@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Guenter Roeck as he was commenting on something writing to the
VGA area...]

On 04/09/2010 10:22 AM, Yinghai wrote:
> 
> then please check this one
> 
> update e820 at first, and later put them resource tree, but give pci BAR chance to claim
> the range, before assign unassigned resources.
> 
> in case some system doesn't have VGA, and use [0xa0000, ..] for mmio of some other pci devices.
> 

Do we have any evidence of any such system?

Either which way, the patch looks saner...

	-hpa
