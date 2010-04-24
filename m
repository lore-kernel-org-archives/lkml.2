Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0DXKrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 06:47:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:39891 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751131Ab0DXKrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 06:47:40 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX182KbxjMfA20cxFyGi/eDZQZ7PEZ0o5N6eHxnx+2x
	jWkflVWWQy6X+6
Message-ID: <4BD2CC46.4060908@gmx.de>
Date: Sat, 24 Apr 2010 12:47:34 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA framebuffer
 driver
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>	<1271614873-5952-11-git-send-email-corbet@lwn.net>	<4BD20D56.7080402@gmx.de>	<20100423155725.7d3b2d2d@bike.lwn.net>	<4BD221E7.7060705@gmx.de> <20100423165256.654ca5eb@bike.lwn.net> <4BD22B96.5020102@gmx.de>
In-Reply-To: <4BD22B96.5020102@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Tobias Schandinat schrieb:
> Jonathan Corbet schrieb:
>> On Sat, 24 Apr 2010 00:40:39 +0200
>> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>> Meanwhile, I'm a little unsure now...is there an action item for me
>> with regard to the i2c code?  I've been staring at it since your last
>> note, but I couldn't find any obvious problems.  I do have to say that
>> Harald's rework is far cleaner than what came before...
> 
> Well the main question is probably:
> How does it change the behaviour towards the hardware?
> I tend to think that OLPC might not be the only ones who did something 
> weird with it....and we already know that we shouldn't trust the 
> documentation too much.

I was able to narrow this issue down to the fourth bus. So with
if (i == 4)
	continue;
in the bus creation loop I'm able to get a working framebuffer which 
does not have the issues mentioned. Any ideas what should be done now?


Thanks,

Florian Tobias Schandinat

