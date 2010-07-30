Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0G3RCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:02:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33536 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0G3RCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:02:17 -0400
Message-ID: <4C53058A.2050408@zytor.com>
Date: Fri, 30 Jul 2010 10:02:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [trival patch]x86: unmap vdso pages are missed
References: <1280476549.10564.2.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1280476549.10564.2.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 12:55 AM, Shaohua Li wrote:
> The memory hasn't been unmapped.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Looks right, but it would be really good if you could provide a more
verbose description about why this is the right thing to do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

