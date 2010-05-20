Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0ETWYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:24:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54611
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab0ETWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:24:19 -0400
Date: Thu, 20 May 2010 15:24:28 -0700 (PDT)
Message-Id: <20100520.152428.112847950.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 07/13] jump label v8: sort jump table at build-time
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100520201728.GA18815@redhat.com>
References: <f9a6149e89c8c0131e1ac1fa5ea163c4f5b023d1.1274283321.git.jbaron@redhat.com>
	<20100519.153634.266077873.davem@davemloft.net>
	<20100520201728.GA18815@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Thu, 20 May 2010 16:17:29 -0400

> btw, how do the sparc bits look?

I have to send you a fix because I use the "call" opcode instead
of the one for "ba".
