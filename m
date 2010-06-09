Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0FIHCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:02:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab0FIHCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:02:48 -0400
Message-ID: <4C0F3C66.1020601@kernel.org>
Date: Wed, 09 Jun 2010 09:01:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jari Ruusu <jariruusu@users.sourceforge.net>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.35-rc2 module reference counting broken
References: <4C0C819E.EA5D6A18@users.sourceforge.net> <20100607064412.GK31073@ZenIV.linux.org.uk> <20100608234814.GA19826@ZenIV.linux.org.uk>
In-Reply-To: <20100608234814.GA19826@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 07:02:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/09/2010 01:48 AM, Al Viro wrote:
>>     block: implement bd_claiming and claiming block
>>
>> I'm far too sleepy right now, but I'd start with reviewing what that
>> thing is doing to module refcounting...
> 
> Yeah...  bd_start_claiming() grabs a reference to gendisk and we never
> let it go.  There's your leak...

Eh, I thought you were cc'd.  Sorry.  This was fixed sometime back by
Nick and queued in block tree (delayed due to mail misdelivery).

  http://thread.gmane.org/gmane.linux.file-systems/40655

Thanks.

-- 
tejun
