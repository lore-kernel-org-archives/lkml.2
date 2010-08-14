Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0HNPBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 11:01:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab0HNPBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 11:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=aqqFM2H7AmwfJVqxPJfxbkHGlDMZcpmrCmb/eGcuAFJVsTDPFPS3AHLleOJRQyqBTZ
         in2cim1Csi8x2zHrKCQOgYKGdvXLc8gqdrW3plGw3e8xUes6IC0mir2qZh5MuTlMB6Sw
         2OXF60bE5A/SzAueAYsIaOo2h8MdLvwyseqGM=
From: Grant Coady <gcoady.lk@gmail.com>
To: "Gabor Z. Papp" <gzp@papp.hu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.52 stable review
Date: Sun, 15 Aug 2010 01:00:56 +1000
Organization: scattered
Message-ID: <brbd66deepdbvvsat5jvjqef9d5ct32ihk@4ax.com>
References: <20100813214704.GA18960@kroah.com> <x6r5i1o3dc@gzp>
In-Reply-To: <x6r5i1o3dc@gzp>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 13:11:43 +0200, you wrote:

>* Greg KH <gregkh@suse.de>:
>
>| If I could get some people to please test this -rc release?
>
>BTW seems like 2.6.27 no more combatible with GNU Make 3.82:
>
>$ make oldconfig
>Makefile:443: *** mixed implicit and normal rules.  Stop.
>
>Same with line 1609.

I have:
grant@deltree:~$ make --version
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-slackware-linux-gnu

and 2.6.27 builds here just fine.

Grant.
