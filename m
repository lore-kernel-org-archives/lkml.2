Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab1DHTs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:48:56 -0400
Received: from mail.wdtv.com ([66.118.69.84]:60001 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715Ab1DHTsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:48:55 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Apr 2011 15:48:55 EDT
From: gene heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Date: Fri, 8 Apr 2011 15:41:39 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.38.2-pclos1.pae; KDE/4.6.2; i686; ; )
References: <1301592656.586.15.camel@jaguar> <4D9E6F6E.9050709@codemonkey.ws> <20110408105952.5e7c2ffb@schlenkerla.am.freescale.net>
In-Reply-To: <20110408105952.5e7c2ffb@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081541.39176.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 08, 2011, Scott Wood wrote:
>On Thu, 7 Apr 2011 21:14:06 -0500
>
>Anthony Liguori <anthony@codemonkey.ws> wrote:
>> If someone was going to seriously go about doing something like this, a
>> better approach would be to start with QEMU and remove anything non-x86
>> and all of the UI/command line/management bits and start there.
>> 
>> There's nothing more I'd like to see than a viable alternative to QEMU
>> but ignoring any of the architectural mistakes in QEMU and repeating
>> them in a new project isn't going to get there.
>
>Supporting only a single architecture sounds like a significant
>architectural mistake...  only x86 deserves clean code?
>
>-Scott

Speaking as someone who hasn't a hand on either end of the oar in this 
effort, please folks, the choice of "KVM" as a name for this project is 
very poor, mainly because it has already been taken by the very commonly 
used little hardware switch that allows one Keyboard, Video, Mouse kit on 
the desktop to service 2 or more computers under the desk.  To all the Joe 
Sixpacks out there who hear that name, and go looking for the box with the 
pushbottons on it to switch computers, it is bound to be very confusing.
Surely there is a short, descriptive name for this that isn't "KVM"?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
"Catch a wave and you're sitting on top of the world."
- The Beach Boys
