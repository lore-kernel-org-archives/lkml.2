Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab0E2ABb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 20:01:31 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:36922 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab0E2ABa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 20:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=njIZMd8pqpR2kcEa1sq1B0s9DeXh31AD+JaWMK2l772uJz1/6MHBYonXIN8qtf3sls
         BSdqHsVNgwtRVqqWnKCL5PEQ03sdsk6RMnZcTcsrPG0JPfp8XLW17DjIsnHToUQS3/Go
         a1XgZXHOFGxVh6FSSu0OXsFnpvou8LiCDlblY=
Message-ID: <4C005957.9040408@gmail.com>
Date: Fri, 28 May 2010 18:01:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Brian D. McGrew" <brian@visionpro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow Disk I/O
References: <C8255AC1.18B68%brian@visionpro.com>
In-Reply-To: <C8255AC1.18B68%brian@visionpro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 12:34 PM, Brian D. McGrew wrote:
> Good morning All!
>
> I¹m running CentOS 5.4 x86_64 on a Dell T5500 with 3GB || 12GB or RAM. I¹m
> running a 2.6.18-128.el5 kernel.  There is a 500GB SATA drive connected to
> the onboard SATA controller.  I can reproduce this problem with CentOS 5.4
> i386 on the Dell T5500, T5400 and Optiplex 740¹s.
>
> So now, on to the problem...  In our software, we¹re reading in 5MP image
> files in the neighborhood of 500 to 1500 files at a time.  Just a simple
> for() loop, open, read, close...  Nothing fancy...
>
> When I have 3GB of RAM in the system, life is good.. Each read takes 8 to
> 10ms...  This is a good thing!
>
> If I bump the memory up to 12GB, all of the reads are now taking 150 to
> 200ms.
>
> My default, va.swappines to set to 60...  If I decrease this number, the
> problem gets much worse.  If I up va.swappines to 100, the problem gets a
> little better, but not a whole lot.
>
> What should I be looking at???

Can you post the dmesg output and the contents of /proc/mtrr?
