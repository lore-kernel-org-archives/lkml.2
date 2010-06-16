Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0FPI1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:27:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55900 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0FPI1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BuTsyptDdbuiYQ4w7MzBJKKZZ37RedqAAuRUC+uZMfInbKIKMf2cHS+2Oyd2uPImR1
         G6f0NeURVEkEoESXSGoM1l7T9cElJEM6V6E9npMIl/62tccrHrIDsfjl+BTuLQh+zvqH
         tBfy1sXbS8jALGt3xla17qz2I022doBQRoVPk=
Message-ID: <4C188AEA.3010109@gmail.com>
Date: Wed, 16 Jun 2010 11:27:22 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-kernel@vger.kernel.org,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: INFO: task khubd:271 blocked for more than 120 seconds.
References: <4C18855E.5010508@gmail.com> <201006161022.32398.oneukum@suse.de>
In-Reply-To: <201006161022.32398.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Oliver Neukum wrote:
> Am Mittwoch, 16. Juni 2010 10:03:42 schrieb roma1390:
>> Hello,
>>
>>
>> We got this on our production system. Kernel: 2.6.26-2-amd64.
>> This seems to be related with http://bugzilla.kernel.org/show_bug.cgi?id=13316 and still is open. Sadly to have such long standing bugs in common used subsystems like USB.
>>
> 
> Under which conditions did you get this? Physical unplug, S3 or S4?
> 
> 	Regards
> 		Oliver

this was normal operation (no unplug, no S3 or something like that). This is on-line
server. There is posible issue with usb device itself or physical usb port. Which
sometimes causes device disconections, reconnections.

Of course it's posible to fix on hardware level, but OS can't do such nasty things also.

