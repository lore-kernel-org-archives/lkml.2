Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0D0AnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:43:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58751 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0D0AnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:43:15 -0400
Message-ID: <4BD63320.8080104@sgi.com>
Date: Mon, 26 Apr 2010 17:43:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v3
References: <20100421193350.GU16427@zorg.emea.sgi.com> <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de> <4BCF80F2.2010906@redhat.com> <20100421232200.GA22877@suse.de> <20100422102852.72837494@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org> <20100425071606.GB1275@ucw.cz> <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org> <4BD5EDF9.6030504@sgi.com> <20100426204648.GC30736@suse.de>
In-Reply-To: <20100426204648.GC30736@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH wrote:
> On Mon, Apr 26, 2010 at 12:48:09PM -0700, Mike Travis wrote:
>> Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max v3
> 
> Your subject is now incorrect, based on the patch.  You should also
> adjust the body of the changelog to reflect the code change.
> 
> thanks,
> 
> greg k-h

Thanks for that catch.  I had changed the name of the patch, but not the subject.

-Mike
