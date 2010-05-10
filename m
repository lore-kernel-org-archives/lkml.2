Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0EJUlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:41:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61742 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0EJUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ld660EMcB6g9vfD1E6H+mMsWqs7zATUBJjXQG7pKTv8/tsivP22ZUfizpFSuRGvi7S
         LEJ+52rzxs4/yPBwIawWHo/I/Nzjb3Hiq5kCDbigMAeeLyVHfTb5oPN3/Z5nHB9vCc0i
         a/8Prpn2tBDf4gSUJ2vGYqF5prUZ4VUVxONrg=
MIME-Version: 1.0
Date: Mon, 10 May 2010 13:41:52 -0700
Message-ID: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>
Subject: magicmouse: claimed by neither input, hiddev nor hidraw
From: Justin Mattock <justinmattock@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is it me, or is there something wrong
with the magicmouse connecting
i.g. I've had my system setup to use the
magicmouse with 2.6.33* with no issues
now coming back after sometime
seems everything is connecting,but then no movement:
(and some thing in dmesg):
[  116.267993] magicmouse 0005:05AC:030D.0007: claimed by neither
input, hiddev nor hidraw
[  116.268053] magicmouse 0005:05AC:030D.0007: magicmouse hw start failed

using osx  magicmouse connects fine.
Using standard mightymouse everything connects.
 are there any reports of such things?


-- 
Justin P. Mattock
