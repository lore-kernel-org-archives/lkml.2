Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2EFMwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 08:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2EFMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 08:52:15 -0400
Message-ID: <4FA673F4.7050501@redhat.com>
Date: Sun, 06 May 2012 15:52:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, gleb@redhat.com,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] kvm: fix cpuid eax
References: <20120502145554.GA2864@redhat.com>
In-Reply-To: <20120502145554.GA2864@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 05:55 PM, Michael S. Tsirkin wrote:
> cpuid eax should return the max leaf so that
> guests can find out the valid range.
> This matches Xen et al.
> Update documentation to match.
>
> Tested with -cpu host.
>
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

