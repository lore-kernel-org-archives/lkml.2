Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab1ENSOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:14:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51982 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab1ENSO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:14:28 -0400
Message-ID: <4DCEC4EB.2050107@zytor.com>
Date: Sat, 14 May 2011 11:07:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Julia Lawall <julia@diku.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: incompatible struct pci_root_info?
References: <4DCEB5BB.1080202@freemail.hu>
In-Reply-To: <4DCEB5BB.1080202@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2011 10:02 AM, Németh Márton wrote:
> 
> As far as I know it is OK to have different types on different architectures
> with the same name. Is there any reason behind having two struct pci_root_info
> delcaration in arch/x86?
> 

It looks like a namespace collision; the same name being used for that
is really two different types.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

