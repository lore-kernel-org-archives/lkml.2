Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0LINoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:44:11 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:35560 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909Ab0LINoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:44:08 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 6629C45E43
Date: Thu, 9 Dec 2010 14:44:06 +0100 (CET)
From: Stefan Achatz <erazor_de@users.sourceforge.net>
To: jkosina@suse.cz, erazor_de@users.sourceforge.net
Cc: rdunlap@xenotime.net, gregkh@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <2069123096.22885.1291902246397.JavaMail.ngmail@webmail07.arcor-online.net>
In-Reply-To: <alpine.LNX.2.00.1012091430130.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091430130.508@pobox.suse.cz> <1290801444.18750.161.camel@neuromancer>
Subject: Aw: Re: [PATCH 0/5] HID: roccat: Achieve userspace notification on
 sysfs attribute creation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 138.246.2.174
X-Arcor-Original-Account: screamingfist@arcor.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 


----- Original Nachricht ----
Von:     Jiri Kosina <jkosina@suse.cz>
An:      Stefan Achatz <erazor_de@users.sourceforge.net>
Datum:   09.12.2010 14:30
Betreff: Re: [PATCH 0/5] HID: roccat: Achieve userspace notification on sysfs
 attribute creation

> On Fri, 26 Nov 2010, Stefan Achatz wrote:
> 
> > Adding sysfs attributes to an already created device raises no userland
> > notification.
> > 
> > Instead of fiddling around in the depths of busses and devices I reuse
> the
> > event char device (module hid-roccat). This device gets now created with
> > a hardware specific class that contains the device attributes.
> 
> Hi Stefan,
> 
> I have applied the series, and removed the #pragma pack ugliness. Thanks,

Hello Jiri,
Using my patch replacing the #pragma pack with the __packed macro would have saved you some time:
https://lkml.org/lkml/2010/11/27/14

Just for the future: Whats better using the verbose version __attribute__ ((__packed__)) or the macro
__packed as I did?

Thanks, Stefan
