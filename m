Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab0E1QNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:13:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:41304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0E1QNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:13:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: =?utf-8?b?0JDQu9C10LrRgdCw0L3QtNGAINCc0YPRgNCw0YjQvtCy?= 
	<alex_mur_spb@mail.ru>
Subject: Re: 0001-This-is-a-patch-to-the-gen-devlist.c-file-that-fixes.patch
Date: Fri, 28 May 2010 18:13:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1OI0Jf-0003LU-00.alex_mur_spb-mail-ru@f10.mail.ru>
In-Reply-To: <E1OI0Jf-0003LU-00.alex_mur_spb-mail-ru@f10.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005281813.16612.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 28. Mai 2010 16:13:39 schrieb Александр Мурашов:
> 
> This is my first patch.Do not judge me harshly, I'm just learning.

I am afraid the first segment creates invalid C.

In addition, even the rules of coding style have to be applied
with some common sense.  Otherwise the result is basically unreadable.

	Regards
		Oliver
