Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2IUQLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:11:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49057 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab2IUQLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:11:38 -0400
Message-ID: <505C9198.7080904@zytor.com>
Date: Fri, 21 Sep 2012 09:11:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: xor-block handling adjustments
References: <504DFB10020000780009A321@nat28.tlf.novell.com> <1347304838.26695.99.camel@sbsiddha-desk.sc.intel.com> <505CA3D9020000780009D0DC@nat28.tlf.novell.com>
In-Reply-To: <505CA3D9020000780009D0DC@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 08:28 AM, Jan Beulich wrote:
> 
> I see (albeit I'm puzzled by the patch there being just 2 days
> old, yet your reply was sent over 10 days ago) - I'll probably
> re-submit once I merged with the 3.7-rc-s, the more that I
> still didn't get anything back from hpa regarding the stack
> alignment compiler option he told me about, but use of which
> I wasn't able to spot anywhere.
> 

Suresh rebased the series at Ingo's request.

	-hpa

