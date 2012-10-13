Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2JMLou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 07:44:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49710 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2JMLot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 07:44:49 -0400
Message-ID: <5079541F.5060308@ahsoftware.de>
Date: Sat, 13 Oct 2012 13:44:31 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121002 Thunderbird/15.0.1
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: linux-kernel@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH RESEND] video/udlfb: fix line counting in fb_write
References: <5029FA0D.1090107@ahsoftware.de> <50756A21.1020700@gmx.de>
In-Reply-To: <50756A21.1020700@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.10.2012 14:29, schrieb Florian Tobias Schandinat:
> On 08/14/2012 07:11 AM, Alexander Holler wrote:
>> Line 0 and 1 were both written to line 0 (on the display) and all
>> subsequent
>> lines had an offset of -1. The result was that the last line on the display
>> was never overwritten by writes to /dev/fbN.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> 
> As Bernie agreed but didn't send me a pull request, I applied this one.

Thanks a lot.

> Though the formatting was screwed up and I had to fix it...

Sorry, must have happened because I've used "Edit as new" in Thunderbird
to resend the patch while just adding the RESEND to the subject.

Good to know.

Thanks,

Alexander

