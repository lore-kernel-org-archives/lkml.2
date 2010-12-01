Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0LAGCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:02:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65093 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab0LAGCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IBdqnseIdzOWKKdmqoDahD+iF0dwZLScXB6wLqJeaUrNinp1+FbcmRZ2eepVU4RA8p
         W9x7autV8rmbta2zlZMr2JvTKqkR/DhFWUbr02I6o1dRW2aSdfrA8n8U9xWW5R7jy1HH
         Oxb5IB80zQSukN/caNDxWXanoRnQyXAgImkmQ=
Date: Wed, 1 Dec 2010 14:07:04 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc3-git installed modules zero bytes long
Message-ID: <20101201060704.GD5210@cr0.nay.redhat.com>
References: <4CF5116B.8040204@blueyonder.co.uk>
 <20101130154855.GA4629@hack>
 <4CF53364.1090807@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CF53364.1090807@blueyonder.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Please don't drop lkml, and I am not a subscriber of the opensuse list.)

On Tue, Nov 30, 2010 at 05:24:52PM +0000, Sid Boyce wrote:
>On 30/11/10 15:48, Américo Wang wrote:
>>On Tue, Nov 30, 2010 at 02:59:55PM +0000, Sid Boyce wrote:
>>>openSUSE 11.3 on one box and openSUSE 11.4 Milestone 4 on the other.
>>>I have a message that says the built modules not found. When I check e.g
>>>/lib/modules/2.7.37-rc3-git7-smp, most modules are zero bytes long.
>>>I have to "make modules_install" and use modprobe on each.
>>>To get the network up on the 11.3 box "modprobe r6189" then "rcnetwork
>>>restart", "modprobe rtl8187", "/etc/init.d/network-remotefs start",
>>>etc., etc.
>>
>>Confused, shouldn't we always run 'make modules_install'?
>>What did you do before that?
>>
>
>As usual a script that does the following and never had problems
>before. It says it's installed the modules, but a check shows they
>are all zero bytes long.
>-------------------------------------------------------------------
>#!/bin/sh
>make -j 4 clean && make headers_install && make -j 4 && make -j 4
>modules_install
>-------------------------------------------------------------------

Hmm, nothing is wrong with this script.

Sounds like a regression, but I don't recall we have any 'module_install'
changes recently.

What does 'make V=2 modules_install' output?

Thanks.
