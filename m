Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab0EMOh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:37:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:36159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0EMOhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:37:55 -0400
Message-ID: <4BEC0EBE.7000404@kernel.org>
Date: Thu, 13 May 2010 16:37:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] libsas: dereferencing variable before check
References: <20100512225629.GB5695@bicker>	 <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com> <1273761114.4353.122.camel@mulgrave.site>
In-Reply-To: <1273761114.4353.122.camel@mulgrave.site>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 14:37:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/13/2010 04:31 PM, James Bottomley wrote:
>> Ooh.. right.
>>
>> Asked-by: Tejun Heo <tj@kernel.org>

That was my first mail from android and of course I typed Asked
instead of Acked.  :-)

> Well, oops, yes.  Two patches to fix one bug is a bit overboard, I
> think, plus some code rearrangement to fix the locality of the problem
> and ensure it doesn't happen again might be useful.  What about this.

Yeap, as long as the silly bug is fixed.

Thank you.

-- 
tejun
