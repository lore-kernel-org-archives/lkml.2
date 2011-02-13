Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1BMUa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:30:29 -0500
Received: from brinza.cc.columbia.edu ([128.59.29.8]:51558 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1BMUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:30:25 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Feb 2011 15:30:25 EST
Message-ID: <4D583E17.80606@rath.org>
Date: Sun, 13 Feb 2011 15:24:55 -0500
From: Nikolaus Rath <Nikolaus@rath.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@ens-lyon.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: virt_to_page for userspace pointers
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu> <878vxuxkfr.fsf@inspiron.ap.columbia.edu> <4D4DC2D6.8030905@ens-lyon.org>
In-Reply-To: <4D4DC2D6.8030905@ens-lyon.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 04:36 PM, Brice Goglin wrote:
>> Is there an equivalent function to virt_to_page (and virt_to_phys) that
>> works with userspace pointers? Or do I have to manually walk through the
>> page tables? In the later case, are there any examples of this kind of
>> search that I could use as a basis?
>>   
> 
> You probably want get_user_pages() (or get_user_pages_fast()).

Thanks for the pointer, that already helped a lot!

I would, however, prefer a more primitive function that just gives me
the struct page without locking it. And if the page is swapped out, I'd
rather get a NULL pointer than having a page frame allocated.  Is there
anything like that?

Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C
