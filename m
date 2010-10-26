Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab0JZVyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:54:18 -0400
Received: from moh1-ve2.go2.pl ([193.17.41.132]:57207 "EHLO moh1-ve1.go2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754293Ab0JZVyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:54:17 -0400
Message-ID: <4CC74E04.7080407@o2.pl>
Date: Tue, 26 Oct 2010 23:54:12 +0200
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SERIAL]blacklist si3052 chip
References: <4CC73085.2070304@o2.pl> <20101026224940.22b4ac93@lxorguk.ukuu.org.uk>
In-Reply-To: <20101026224940.22b4ac93@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 68
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26.10.2010 23:49, Alan Cox pisze:
> On Tue, 26 Oct 2010 21:48:21 +0200
> Maciej Szmigiero <mhej@o2.pl> wrote:
> 
>> [SERIAL]blacklist si3052 chip
>>
>> Si3052-based softmodems aren't serial ports so don't bind serial driver to them.
>> Allows proper driver to bind to them.
> 
> Which is the proper driver ?
> 
> Alan
> 

Awaiting final review on the DAHDI reviewboard.

Maciej Szmigiero

