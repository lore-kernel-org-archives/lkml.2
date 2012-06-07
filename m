Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab2FGQb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:31:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50213 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2FGQb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:31:27 -0400
Message-ID: <4FD0D67E.3080506@zytor.com>
Date: Thu, 07 Jun 2012 09:27:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Andre Przywara <andre.przywara@amd.com>, Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] x86, AMD: Fix crash as Xen Dom0 on AMD Trinity systems
References: <1338562358-28182-1-git-send-email-bp@amd64.org> <1338562358-28182-4-git-send-email-bp@amd64.org> <4FCFD2EE.8060508@zytor.com> <20120607072159.GB9856@aftab.osrc.amd.com> <4FD05CED.60905@amd.com> <20120607080833.GA23186@kroah.com>
In-Reply-To: <20120607080833.GA23186@kroah.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 01:08 AM, Greg KH wrote:
> 
> What?  So I don't need to do anything?
> 

Correct, you're fine as-is.
	
	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

