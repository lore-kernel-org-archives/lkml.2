Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2KZTQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:16:40 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41445 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2KZTQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:16:39 -0500
Message-ID: <66B0C9D116EC402CAFB33B13AEC1F251@Chronos>
From: "Michael D. Burkey" <mdburkey@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "Christoph Fritz" <chf.fritz@googlemail.com>,
        =?iso-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
        "Sascha Hauer" <s.hauer@pengutronix.de>
References: <20121122004212.371862690@linuxfoundation.org> <20121122004216.531273574@linuxfoundation.org> <8DA3043795C340758B9AEB1BCA791676@Chronos> <20121126184436.GB21012@kroah.com>
In-Reply-To: <20121126184436.GB21012@kroah.com>
Subject: Re: [ 35/83] ARM: imx: ehci: fix host power mask bit
Date: Mon, 26 Nov 2012 14:17:28 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6002.18005
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7601.17609
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a needed fix -- but there are other fixes that probably need to go 
along with it.
I'm still trying to figure out exactly what all needs to change alongside 
it.

----- Original Message ----- 
From: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Michael D. Burkey" <mdburkey@gmail.com>
Cc: <linux-kernel@vger.kernel.org>; <stable@vger.kernel.org>; 
<alan@lxorguk.ukuu.org.uk>; "Christoph Fritz" <chf.fritz@googlemail.com>; 
"Eric Bénard" <eric@eukrea.com>; "Sascha Hauer" <s.hauer@pengutronix.de>
Sent: Monday, November 26, 2012 1:44 PM
Subject: Re: [ 35/83] ARM: imx: ehci: fix host power mask bit


> On Wed, Nov 21, 2012 at 11:52:25PM -0500, Michael D. Burkey wrote:
>> This patch is definitely needed -- it is obviously setting the wrong
>> bit --  but I am still doing testing to see what other complications
>> may arise from actually setting the RIGHT bit (i.e. I've seen some
>> odd results so far and suspect some other code may have been changed
>> historically to account for the wrong behaviour this bit was
>> causing).
>>
>> We're currently on vacation for Thanksgiving over here in the USA
>> and I won't be back in the office til next week.
>>
>> If you would, hold off on adding the patch to the stable kernel
>> until I have a bit more time to check out a couple of things.
>
> As it's already in Linus's tree, one would have hoped that the patch
> would have been tested already :)
>
> I'll leave it in the stable tree, if it's a problem, please get the fix
> into Linus's tree, and then have that fix submitted to the stable kernel
> trees.
>
> thanks,
>
> greg k-h 

