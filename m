Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0DSGsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 02:48:50 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:34413 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0DSGss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 02:48:48 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 02:48:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Yp2TSV5hX+1Fapkr+siycckLW2FWa6WPjWSGtWj23emEMITusMw2MfHQRmk8hsB69r
         AbJq9viOscQZOwwmubL7IdDkqQsjKB2Tslx7/PFurvzZCc57TUObWDiRu2o8K8O51LkE
         4PEbMW1w35HLP/1JzZ710DZL/ZxntGcRBg38U=
Message-ID: <4BCBFBA9.9040606@gmail.com>
Date: Sun, 18 Apr 2010 23:43:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ben Gamari <bgamari.foss@gmail.com>
CC: gcc@gcc.gnu.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com> <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com>
In-Reply-To: <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 10:35 PM, Ben Gamari wrote:
> On Sun, 18 Apr 2010 21:19:19 -0700, Justin Mattock<justinmattock@gmail.com>  wrote:
>> so far I've compiled most of the system
>> (glibc,Xserver,etc..)
>> and not really anything has crashed and burned
>> except for the kernel:
>>
> You are using a pre-release compiler. It should be no surprise that it chokes
> on the kernel. You should do as the compiler said and report this to the gcc
> folks.
>
> - Ben
>
>


I couldn't resist..(had to play),
anyways I looked through the reports
but didn't see anything that was
familiar. so I went and created an entry:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43791

Justin P. Mattock
