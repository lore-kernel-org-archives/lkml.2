Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0KPSRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:17:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39872 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab0KPSQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PA7+kDHYnScksCUOzg/WhnzD2ZWeL7BYB40J2fKa8ks8HqWhiKUXQW3plfHkm7S/du
         7pvdC/OelW2wJgLsAi92aVMjVsy/9Hb0oQEmkI52Gk+xxLkA3Hxx+WXA4T0vNWLumXuG
         SiSqPmN5kta0fcQ23Pdhs1pLvlYYAUhpHHwuQ=
Subject: Re: [RFC][PATCH v2] irq_work: Drop cmpxchg result
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
References: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 19:16:53 +0100
Message-ID: <1289931413.5372.509.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 16 novembre 2010 à 12:02 -0600, Sergio Aguirre a écrit :
> This solves this compilation warning:
> 
> kernel/irq_work.c: In function 'irq_work_run':
> kernel/irq_work.c:148: warning: value computed is not used

Just curious, what is your compiler version ?

Thanks


