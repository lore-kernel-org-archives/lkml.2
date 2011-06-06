Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1FFSoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:44:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1FFSn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rJpwckP2lKAPdyM+48DXLNC+89ta4cn4LrvzaoZqxz6Hyf/YORb+FUfizQRnooD+Gp
         ibZDCFq+6IjtG949F1y33i8oGCItyUdgoGUDFSMbe6qNJyhkj/AusY/hI9tTKOY3jtYr
         Qv8W/coXwME7a4D9xHQwe8cv1sV2C1YR4Rlnw=
MIME-Version: 1.0
In-Reply-To: <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-4-git-send-email-fweisbec@gmail.com> <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 6 Jun 2011 14:43:37 -0400
X-Google-Sender-Auth: bz98K1opxVr0n5EzFVBK4QiEkNs
Message-ID: <BANLkTimWuM7baYvGv8=woNGA8KVuujG53A@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] nohz: Split extended quiescent state handling from
 nohz switch
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 23:20, Frederic Weisbecker wrote:
>  arch/blackfin/kernel/process.c         |    4 +-

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
