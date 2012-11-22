Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2KVUJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:09:06 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33036 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab2KVUI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:08:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121122195840.GA26543@kroah.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
	<20121122195840.GA26543@kroah.com>
Date: Thu, 22 Nov 2012 21:08:55 +0100
Message-ID: <CAJSP0QUai4O12U7fbrARAZLOig5=10e1WYg7i+OZTDETuDRWoQ@mail.gmail.com>
Subject: Re: [PATCH 00/46] staging: line6: drop MIDI state sysfs attrs
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Markus Grabner <grabner@icg.tugraz.at>,
        "line6linux-devel@lists.sourceforge.net" 
	<line6linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 8:58 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 22, 2012 at 08:48:39PM +0100, Stefan Hajnoczi wrote:
>> Markus and I have discussed the MIDI processing that currently happens in the
>> line6 driver.  This stuff really belongs in userspace where a library or
>> utility can use ALSA MIDI APIs to control the device.  Moving MIDI processing
>> to userspace has several benefits:
>>
>> 1. The driver only handles PCM and MIDI I/O.  This means less kernel code.
>>
>> 2. A large number of sysfs attributes can be removed.  These attributes exposed
>>    MIDI state and driver code was necessary to sync and manage this state.
>>
>> 3. It's easier for userspace to control the device, try out new MIDI commands,
>>    etc when the driver acts as a dumb transport.
>>
>> This patch series removes the sysfs attributes and then removes the state
>> behind those attributes.  I have tried to make small incremental changes that
>> can be reviewed easily.
>
> Very nice, I'll queue these up on Monday, very good work, thanks so much
> for doing this.

Thanks!  I hope Markus has a chance to review and/or test these
changes first - he knows generally what I'm up too but should have the
final word on details.

Stefan
