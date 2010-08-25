Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0HYVMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:12:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52440 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0HYVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=U42fej8kQcfZzSr2hACiWa3ME90NJx2y8D+96uhFGeoGcg6eUatOOYSleLj7gqMXHU
         6ETfHgtAtJFHZr7HvJjmYf6pw30VreaGLT0MZqYH3dCdWCVxr3+bFIyz0HhxOeGVEoPo
         uEEVBJJkcWN/Uah5QACJreWXvaCph24MtWSjk=
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 14:12:50 -0700
Message-ID: <AANLkTikw9y5sTHNfCq0qGfn_nyRpvQAm6Ezusneq5Umz@mail.gmail.com>
Subject: vesafb not loading during boot and lilo gives no video modes
From: Justin Mattock <justinmattock@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lilo-devel@lists.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
Ive been building a clfs system, and have been racking my brain around
as to why vesafb is not loading at boot.. using any option in
lilo.conf
(vga=normal,893,ask) gives nothing but the no modes found.

under dmesg on the machine that doesn't work I see
[    0.000000] Console: colour EGA 80x25

and on the good machine(same setup older packages)I see
[    0.000000] Console: colour dummy device 80x25

is there something Im missing in userspace to cause lilo to not
respond to vga=893, ask, normal but only go to EGA?

-- 
Justin P. Mattock
