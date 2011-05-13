Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab1EMR1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:27:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63249 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab1EMR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OEAzhdtmKz0uGrMj3FRzK/6qtZg76HMf7tPTMLk+DwGFt4RBFNGfesLrgMVeIBX7Vo
         rAa19x8CUBzA7TuKTkH1pnt2qRQHlDDpxYsDlK4XTV0S5QJE9SuaZxp4yL1HzYwWtSEa
         yRFbjd0dPdj++qoYuK3Hymk2itsRHYCmx/Ebw=
Subject: Re: kernel BUG at net/ipv4/tcp_output.c:1006!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: TB <lkml@techboom.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <4DCD6658.3020901@techboom.com>
References: <4DCD6658.3020901@techboom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 19:27:13 +0200
Message-ID: <1305307633.3866.61.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 mai 2011 à 13:11 -0400, TB a écrit :
> This is the 2.6.38.5 kernel with the patch in
> [PATCH] tcp_cubic: limit delayed_ack ratio to prevent divide error
> 
> Had this crash a few days ago, but never got any response to subsequent
> emails. Another server crashed today with a network related backtrace,
> but netconsole did not work.

I understand you are anxious, but sending this message to lkml will
hardly find more people to look at this problem.

You sent your messages two days ago on netdev, thats not like its one or
two months.

Please send us full disassembly of tcp_fragment (from vmlinux file)



