Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267Ab0CPSwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:52:40 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:59625 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803Ab0CPSwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XgjUPadHg0G4RkmJxJAJZijM2UJQk1+eu7p5346285Ry07jJ5N4Szc0IjokvacHwoj
         QUR8x6Gn65Jq0vAP5dIpKH+NYFAAsbCQXLq010d+GV4XOKX0/q43ecxXwChbBjOxeusv
         JR+p4wG5g4xKrtg7W/NAPWeasKu+KdZgFkvtM=
MIME-Version: 1.0
In-Reply-To: <20100315201713.GA3779@elf.ucw.cz>
References: <1268622355-9966-1-git-send-email-chihau@gmail.com>
	 <20100315053352.GC11552@elf.ucw.cz>
	 <f5ca57691003151108o5698e549g6c9a78495d6525f@mail.gmail.com>
	 <20100315201713.GA3779@elf.ucw.cz>
Date: Tue, 16 Mar 2010 14:45:39 -0400
Message-ID: <f5ca57691003161145w61b7f500x9219036cb97cceb5@mail.gmail.com>
Subject: Re: [PATCH] Staging: dream: generic_gpio: Use linux instead of asm 
	uaccess.h
From: Chihau Chau <chihau@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No I don't know how to test it in my G1.

2010/3/15 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> Sorry I have been confused with the description of another patch.
>>
>> I will fix the description.
>>
>> Thanks Pavel!
> ...
>> > ...plus, was the patch actually tested?
>
> I'd still like to know if it was tested...
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Chihau Chau
