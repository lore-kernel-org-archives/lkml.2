Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0H0WdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:33:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54857 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0H0WdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=slHyf3wPl/HeKA6PO5zTcTMqadVMowLkSjAD32O5DFp7bquzP3MxH3tNQ2aimgvOLI
         Gj0FYDIbtiYoRMGYT4srZSbPjzGs+cbwOCTUNJgCaaSltm5NGXGpKh0mK3IGBCzCUvVb
         KeKv2jYLwLzDYBQ4JgCKjhp3GylK9aBm7P3s0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
Date: Fri, 27 Aug 2010 15:33:01 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2+; KDE/4.4.5; x86_64; ; )
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com
References: <4C7838DD.1020004@codeaurora.org>
In-Reply-To: <4C7838DD.1020004@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008271533.01542.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 27, 2010 03:14:53 pm Neil Leeder wrote:
> This is an update of the keyboard driver which Quanta previously posted
> to linux-input. Like the touchpad driver, I'm taking over maintenance
> for code aurora forum.
> 
> The keyboard is attached to an embedded controller which is accessed
> through I2C. It has a dedicated I2C address and its own interrupt line,
> so it is not treated as an mfd. Although a PS/2 command, 0xF4, is used
> to initialize the keyboard, the EC does not respond to other PS/2
> commands. I have tried a serio driver on the port and attempted to use
> keyboard drivers like xtkbd to communicate with it. These fail for
> similar reasons to those discussed in the qci touchpad thread. This is
> the reason for having this as a stand-alone driver.
>

No, this is crazy... This is a twin-brother of the touchpad driver and
I really do not understand why chip claiming to have PS/2 interface
(3 ports if I were to believe the diagram) would not allow us talk to
the devices...

-- 
Dmitry
