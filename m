Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0HIVan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:30:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab0HIVam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:30:42 -0400
Message-ID: <4C60733C.2040405@kernel.org>
Date: Mon, 09 Aug 2010 23:29:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Garzik <jeff@garzik.org>, David Howells <dhowells@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Steve French <sfrench@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Walls <awalls@radix.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [GIT PULL] workqueue for v2.6.36
References: <4C596D21.4080101@kernel.org> <AANLkTimfmJsUSMw9AuOo3sf_n8hUUMDqvAD13FhZZans@mail.gmail.com> 	<20100809200945.GA1595@arch.tripp.de> <AANLkTikS=N7sW0eJJRRJrTXMuihuCmxRP=TFmYi0=7Et@mail.gmail.com>
In-Reply-To: <AANLkTikS=N7sW0eJJRRJrTXMuihuCmxRP=TFmYi0=7Et@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 Aug 2010 21:29:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On 08/09/2010 10:18 PM, Linus Torvalds wrote:
> On Mon, Aug 9, 2010 at 1:09 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On Mon, Aug 09, 2010 at 01:05:31PM -0700, Linus Torvalds wrote:
>>>
>>> I'll bisect it all the way, but thought I'd let you know.
>>
>> No need to, it's already fixed:
>> http://lkml.org/lkml/2010/8/9/94
> 
> Right you are. That patch fixes it for me too.
> 
> Tejun, please send me a pull request for the fixes (or patches). I
> hate picking up patches that haven't been explicitly sent to me.

Oh, sorry about that.  I was gonna send a pull request tomorrow.
Sending it right now.

Thanks.

-- 
tejun
