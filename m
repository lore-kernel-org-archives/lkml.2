Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0IEVE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 17:04:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0IEVEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 17:04:39 -0400
Message-ID: <4C8405E0.7060107@redhat.com>
Date: Mon, 06 Sep 2010 00:04:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Someone Something <fordhaivat@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh <greg@kroah.com>
Subject: Re: LDD examples
References: <AANLkTim7eHwkbbOHdXax7dQiMzSAktxjNYBpQjKOwTUy@mail.gmail.com>	<20100903110158.aadf7850.rdunlap@xenotime.net> <20100904114445.3f008551@bike.lwn.net>
In-Reply-To: <20100904114445.3f008551@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/04/2010 08:44 PM, Jonathan Corbet wrote:
>> The examples are certainly out of date.
> The entire book is out of date - it's from 2.6.10!
>
> We are (very slowly) pondering ways to update it; I hope to get
> something going in the near future.  Stay tuned...
>

Merge it into Documentation/books/, and have kbuild build all the examples?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

