Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0FJR3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:29:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49563 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab0FJR3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SxqqBilznsybU8s/4JN+eITpYsI6cGi6zqUOWXBAyt1wQaJyRS+YMkQj6OHU3SCMN2
         atVhES0Werm0+Hdq9Xyr9x8jv808HshqFxc6BIp4io68j/IxmLilX4XNnsQNnrohviIP
         GvZFf7SpqYp4T9xcSVEtarnt18xZjHlyLJjpM=
MIME-Version: 1.0
Date: Thu, 10 Jun 2010 11:29:46 -0600
Message-ID: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
Subject: Aerospace and linux
From: Brian Gordon <legerde@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

    I work in the aerospace industry and one of the considerations
that occurs in aerospace is a phenomenon called Single Event Upsets
(SEU).   I'm not an expert on the physics behind this phenomenon, but
the end result is that bits in RAM change state due to high energy
particles passing through the device.   This phenomenon happens more
often at higher altitudes (aircraft) and is a very serious
consideration for space vehicles.

    When these SEU can be detected some action may be taken to improve
the behaviour of the system  (log a fault and reset in order to
refresh things from scratch?).   So the first question becomes how to
detect an SEU.   Flash is considered somewhat safer than RAM.   When
executables run in linux, do the .text and .ro sections get copied
into RAM?  If so, can a background task monitor the RAM copy of .text
and .ro for corruption?     Tripwire seems to offer this kind of
detection as a means for detecting tampering by a malicious attacker
in the filesystem, but I am not convinced that it would detect
modifications to copies of the ELF in RAM.

   My understanding how linux does "on-demand" loading of executables
may be a problem here.   But this SEU detection capability would seem
to have some applicability to intrusion detection, so I have to think
some mechanism already exists.

  Thank you to anyone for any pointers on where I can look to learn
more about detecting SEU in linux.

legerde at gmail com
