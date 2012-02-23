Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2BWWt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:49:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2BWWtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:49:24 -0500
Message-ID: <4F46C253.106@zytor.com>
Date: Thu, 23 Feb 2012 14:48:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com> <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com> <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com> <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com> <20120223215242.GA1306@1wt.eu> <CA+55aFyxB4kmmSOKDSRkAkaRx=G7o7JnuUGBu3_WVr9KbpWWYQ@mail.gmail.com> <20120223222733.GB1306@1wt.eu> <CA+55aFxztx=Cf8i+jZE=X8Zx1BZnNpC6wv-PkWcXDfBFS6qWqg@mail.gmail.com>
In-Reply-To: <CA+55aFxztx=Cf8i+jZE=X8Zx1BZnNpC6wv-PkWcXDfBFS6qWqg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 02:38 PM, Linus Torvalds wrote:
> 
> You'd still need an x86-32 machine to test on, because x86-64 was
> immune to this issue.
> 
> But yeah, the impact of this seems to be small enough that for older
> kernels (which are likely used on older systems for maintenance
> anyway) disabling AES-NI on x86-32 really might be the way to go.
> 

That would really suck for users of encrypted hard disks.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

