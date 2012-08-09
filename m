Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab2HIUBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:01:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab2HIUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:00:03 -0400
MIME-Version: 1.0
Date: Thu, 9 Aug 2012 17:00:02 -0300
X-Google-Sender-Auth: siHY5tmMTmw_Rnh1K-n5SwaVyv8
Message-ID: <CAP9ODKrSSEs+8t+TsMAwK3ncuTma9HJH=UndDYJ-zmyEgCXU4Q@mail.gmail.com>
Subject: Boot freeze after/during PCI initialization
From: Otavio Salvador <otavio@ossystems.com.br>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

One of machines we have freeze during initialization from time to time:

freeze at: http://download.ossystems.com.br/~otavio/geode-freeze.jpg
works at: http://download.ossystems.com.br/~otavio/geode-working-dmesg.txt

This happens with 3.4 and 3.5 kernel and seems to not happen with 3.0.

Any clue what might be causing it?

-- 
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
