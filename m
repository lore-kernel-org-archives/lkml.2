Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1EZFV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:21:57 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:39992 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab1EZFVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=x6pSLUWzJFeJdRJIDKrcvU1Jjy3L+gYiBcVqGFVkTCjVXotcoaelUF7w8hJ4h7D1+S
         jzTH4NP1XeK/SJPY17lbmxHh/1mT81pVSfrj1YXWmsKUI7KqsueP3osBFu1IYX9XiWWL
         NhI+ZRbqs5kpZ/KnRYWVGwDCQP3ii/Adj9bdM=
References: <20110526013423.GA25226@redhat.com> <4DDDD47C.5030504@gmail.com> <20110526043337.GA11224@redhat.com> <20110526051109.GA11870@redhat.com>
In-Reply-To: <20110526051109.GA11870@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <1D85F0D7-64FB-4FF4-A8CC-62D5AED19757@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
X-Mailer: iPhone Mail (8C148)
From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: no sound in current -git
Date: Wed, 25 May 2011 22:22:21 -0700
To: Dave Jones <davej@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org






On May 25, 2011, at 10:11 PM, Dave Jones <davej@redhat.com> wrote:

> On Thu, May 26, 2011 at 12:33:38AM -0400, Dave Jones wrote:
> 
>>> sound over here is out as well on a macbook pro. seems gnome shell 
>>> didn't like whats being merged with the current Mainline i.g. no sound 
>>> bluetooth applet missing. will bisect when I get a chance.
>> 
>> Maybe it was this that just got merged..  (building now)
>> 
>> commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
>> Author: Eric Paris <eparis@redhat.com>
>> Date:   Wed May 25 19:49:18 2011 -0700
>> 
>>    tmpfs: fix XATTR N overriding POSIX_ACL Y
> 
> Yep. That fixes sound for me.
> Sorry for the false alarm Takashi!
> 
>    Dave

Cool!!, will test over here once I finish other tasks.
> 

Justin P. Mattock
