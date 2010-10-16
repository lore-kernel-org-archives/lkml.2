Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0JQAD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:03:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41873 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab0JQAD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=To02/md5wDZj6y4SG3iBID3+x2zD8Jkfs7Gt24PjDe+HBTT/mH7Tb7GcAoovIqWVYy
         AtY2XmlRWyRTMiR6jXBeK/uLR4UYH36oSDSC+tWsTqXmoRHMqt5BnQLS2Mog7CflVbzA
         W+XmGGJuU0u7/9bkkq0WYYoWcL7Nr11s6KTPg=
MIME-Version: 1.0
Date: Sat, 16 Oct 2010 18:08:55 -0500
Message-ID: <AANLkTikBeA2PRoPc7_eLRXCd0cf4u1SV-B_ePYoB_Kt1@mail.gmail.com>
Subject: repeated drive messages why?
From: Caleb Cushing <xenoterracide@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ever since I switched to new hard drives and mdraid I get this in my
logs sever times a day and I don't know why. Is it a problem? (not on
list, please cc me)

EXT4-fs (md1): re-mounted. Opts: commit=0
EXT4-fs (md2): re-mounted. Opts: commit=0
EXT4-fs (md3): re-mounted. Opts: commit=0
ata1.00: configured for UDMA/133
ata1: EH complete
EXT4-fs (md1): re-mounted. Opts: commit=0
EXT4-fs (md2): re-mounted. Opts: commit=0
EXT4-fs (md3): re-mounted. Opts: commit=0
ata1.00: configured for UDMA/133
ata1: EH complete
EXT4-fs (md1): re-mounted. Opts: commit=0
EXT4-fs (md2): re-mounted. Opts: commit=0
EXT4-fs (md3): re-mounted. Opts: commit=0
ata1.00: configured for UDMA/133
ata1: EH complete
EXT4-fs (md1): re-mounted. Opts: commit=0
EXT4-fs (md2): re-mounted. Opts: commit=0
EXT4-fs (md3): re-mounted. Opts: commit=0


-- 
Caleb Cushing

http://xenoterracide.com
