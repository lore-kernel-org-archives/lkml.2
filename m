Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0FCQxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:53:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33958 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0FCQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Jj958ilFzTlyAn22XyLdyEKoyAEtrobR8dY8JToyQ7i+QFqDSCeMFZsuzrddIqnlum
         svMkpwWrUOTSso7HL87viX653rOQ7zOcwuRYkjWSa+KLKJA+NZVnQkuTiqYMbFhmzPUa
         6NoC+1RLWbtFxOAvIUG6/bbOSQIvJSjcnJh4c=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Date: Thu, 3 Jun 2010 12:53:25 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       linux-usb@vger.kernel.org
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de> <201006031221.56150.gene.heskett@gmail.com> <20100603162655.GA6728@suse.de>
In-Reply-To: <20100603162655.GA6728@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031253.25049.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010, Greg KH wrote:
>On Thu, Jun 03, 2010 at 12:21:56PM -0400, Gene Heskett wrote:
>> How soon can this get in?  I ask because I have been crippled in all
>> attempts to use an ftdi adaptor to talk to an old legacy machine I have
>> for about that long now. xon/xoff seems completely broken, and 7wire
>> seems to scramble things to the point where no null modem cable I have
>> made (and I have a book on them) will allow the 7wire flow controls to
>> function.
>
>Give it a week or so to get out to all the stable kernel releases.
>
>thanks,
>
>greg k-h
>
Thanks Greg.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Well, the handwriting is on the floor.
		-- Joe E. Lewis
