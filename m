Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CGSfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:35:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45057 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1CGSfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=n8HpPEyvw2oLLzX51X0DhQqO15XYB00fELAwgEa3PvluQIfWL4wkewX13p2qQPSakn
         RV/riv5z0McQT7+FjrPAvpvhMRLzF5DeDuk7ecipJr3LCdHFH/JxPCCs8nHhvgnFh/6P
         2Go5IKnAxvk3hM/XV4QIdOxfY3L+hob5Ho+Fo=
MIME-Version: 1.0
Date: Mon, 7 Mar 2011 19:35:22 +0100
Message-ID: <AANLkTimNn7XK_fjZpfxXn0WZg1CFaQr3tH2+P6uOgXK5@mail.gmail.com>
Subject: fanotify documentation
From: Belisko Marek <marek.belisko@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there possibility to get some actual interface documentation about
fanotify userspace interface
(most of google results point to obsolete socket interface). I'm trying to use
this (http://git.infradead.org/users/eparis/fanotify-example.git) example.

Use 2.6.37 kernel with fanotify enabled trying to track file changes in some
directory but no results when create new file of modify existing. Works only if
call fanotify example to existing file.

Try sudo ./fanotify -o modify,open,close,access /home/* (end with
Invalid argument) also without * at the end doesn't help.

Any ideas why? Fanotify allow only to track files (not recursive directories)?


Thanks in advance,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
