Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0EMBCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:02:33 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:37644 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0EMBCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OzG1rbyGLfOsEoOQLfhqIHZFo3jVYybdDzr+JYDrumPveKXoKTSR+iIvxp+0YmPz0I
         1/yuClR2mRSCTUCyRzT6uzLp7rqVCt6XcAM12EgEzm7ta+N7jmyAUlGcnSp+91mxa/xT
         QDRu2ALpJIkrIAYv7WKq9HCsxJynjhoCqr0ug=
Message-ID: <4BEB4FA3.70308@gmail.com>
Date: Wed, 12 May 2010 19:02:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: T500 cdrom drive never stops spinning until mount.
References: <20100512023549.GA22623@cpu18.student.cs>
In-Reply-To: <20100512023549.GA22623@cpu18.student.cs>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 08:35 PM, Nick Bowler wrote:
> The ThinkPad T500 has a SATA cdrom drive attached to an Intel ICH9M/M-E
> SATA ACHI controller.  Upon inserting a disk into this drive, if sr-mod
> is loaded, the disk will never stop spinning by itself:  it will spin up
> to full speed, then start slowing down, but just before it stops, it
> will spin up to full speed, then start slowing down, ad infinitum.
>
> If sr-mod is not loaded, the disk stops spinning right after insertion.
> It is only possible to remove sr-mod when the disk is spinning at full
> speed (all other times the module is in use), and then the disk stops.
>
> Mounting the disk also causes it to stop spinning (and it remains
> stopped after unmounting it).
>
> I see this behaviour with both 2.6.32 and 2.6.34-rc7.

Is something like hal, devicekit, etc. accessing the drive in this case? 
Can you try a minimal boot with no unnecessary processes and see if the 
same thing happens?
