Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1FSJl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:41:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40123 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1FSJlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gQi3goJv1MY9OGujl3ie8hf6TcCj1EyHk1EfOIwyl959HMsJk/8XEUpi27HBDTUBbW
         U2kvY1mk+xcYC+jPwy4HDzrFHcM5GRvxrtswa+9aCj9oeX/He4+JG1NREVDUDO5LPGUM
         BQ4yBgpaxBbKaR6sUHyrHYaExGPygMQ23ZbpQ=
MIME-Version: 1.0
In-Reply-To: <20110618214203.0028ba85@debxo>
References: <20110618213803.521db1b3@debxo>
	<20110618214203.0028ba85@debxo>
Date: Sun, 19 Jun 2011 10:41:22 +0100
X-Google-Sender-Auth: Vdon1VSL-eQsqxi46jkPFmQSv0c
Message-ID: <BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, cjb@laptop.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com,
        libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2011 05:42, Andres Salomon <dilinger@queued.net> wrote:
>>  LICENCE.OLPC                 |   33 +++++++++++++++++++++++++++++++++
>>  WHENCE                       |   20 ++++++++++++++++++++
>>  libertas/lbtf_sdio.bin       |  Bin 0 -> 120924 bytes
>>  libertas/lbtf_usb.bin        |  Bin 0 -> 118888 bytes
>>  libertas/sd8686_v9_OLPC.bin  |  Bin 0 -> 124244 bytes
>>  libertas/usb8388_v5_OLPC.bin |  Bin 0 -> 127824 bytes
>
> Of course, if people would prefer the OLPC version to supersede the
> ones currently in the linux-firmware tree, I can do that instead.  I
> don't know what versions of sd8686.bin and usb8388.bin are actually in
> the tree.  I also don't know if the OLPC versions improve or make things
> worse for people using those chips on non-OLPC systems.

This overlaps with a submission I made the other day (of usb8388
firmware), sorry for the lack of coordination there.

I don't think the OLPC hardware has any quirks or special features
that mean it requires special firmware.

However, for the usb8388 we do use a special firmware developed by
Cozybit (not Marvell), the one you submitted, which has its own
versioning scheme. The main difference is that it includes mesh
support. I am pretty sure it would run on any usb8388 but OLPC is the
only user of the hardware anyway. See
http://lists.infradead.org/pipermail/libertas-dev/2010-November/003330.html
and the rest of the discussion.

As for sd8686, I thought our firmware was standard, from Marvell, and
simply a newer version of what is in linux-firmware. Do you have
reason to believe otherwise?

Thanks,
Daniel
