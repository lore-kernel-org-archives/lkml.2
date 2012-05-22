Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2EVOze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:55:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37528 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094Ab2EVOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:55:32 -0400
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2012 10:55:32 EDT
X-Sasl-enc: T8Jbunbvtu3Gbf5odvu3OSf929P2LTgKCTLFby7iPv5N 1337697857
Message-ID: <4FBBA63F.2050501@fastmail.fm>
Date: Tue, 22 May 2012 15:44:15 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, deathonfuneral@gmail.com
Subject: Re: struct tty_flip_buffer replacement in newer kernels
References: <CAMMxdh1Ak2LWeL=3qxTmvfR43E=wSHz5OmSj_irMubz0aK+TgA@mail.gmail.com> <4FBB8742.7050504@fastmail.fm> <20120522151033.33ef577a@pyramind.ukuu.org.uk>
In-Reply-To: <20120522151033.33ef577a@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-adding original poster an LKML after I accidentally dropped them.
 Sorry about that]

On 05/22/2012 03:10 PM, Alan Cox wrote:
>> I'm newbie, working under existed serial driver, adapting it for 2.6.32.
>> During the compilation I have had several problems, which I
>> succesfully solved except this one:
>> error: 'struct tty_struct' has no member named 'flip'
>> In particular, cound you advice correct replacement of "tty->flip.count"
> 
> Your driver shouldn't be looking in those areas. There isn't a correct
> replacement. You will need to update it to use the flip buffers properly
> not poke its nose in places it shouldn't have.
> 
> Perhaps the best thing would be to post a link to the driver ?
> 
> Alan

