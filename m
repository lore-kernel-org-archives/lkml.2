Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2IMWp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:45:56 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56685 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab2IMWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:45:54 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z21eIzbb2dI98dI1432Izz1202h1d1ah1d2ahzzz2fh2a8h668h839hd25hf0ah107ah10d2h1288h12a5h12a9h12bdh1315h1155h)
Message-ID: <5052621B.6020204@am.sony.com>
Date: Thu, 13 Sep 2012 15:45:47 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 0/2] [ANNOUNCE] 3.0.42-rt64-rc1 stable review
References: <20120913185234.912247144@goodmis.org>
In-Reply-To: <20120913185234.912247144@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/12 11:52, Steven Rostedt wrote:
> 
> Dear RT Folks,
> 
> This is the RT stable review cycle of patch 3.0.42-rt64-rc1.

Tested on:

  - ARM mpcore
  - ARM panda

For configurations:

  - SMP CONFIG_PREEMPT_NONE
  - UP  CONFIG_PREEMPT_NONE
  - SMP CONFIG_PREEMPT_RT_FULL
  - UP  CONFIG_PREEMPT_RT_FULL

Tests:

  - build
  - boot
  - magic SYSRQ prints on serial console

As expected, panda SMP CONFIG_PREEMPT_RT_FULL still has the
lock warning on boot.  (tglx is looking into this.)

-Frank

