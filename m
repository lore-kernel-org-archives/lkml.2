Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1LLX7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:59:38 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27941 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1LLX7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:59:35 -0500
X-SpamScore: -16
X-BigFish: VPS-16(z21eNzbb2dI1432N98dKzz1202hzzz2fh668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EE69559.8030200@am.sony.com>
Date: Mon, 12 Dec 2011 15:59:21 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.0.12-rt30
References: <1323302027.30977.117.camel@frodo>
In-Reply-To: <1323302027.30977.117.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/11 15:53, Steven Rostedt wrote:
> 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0.12-rt30 stable release.
 
Builds and boots on some ARM boards

  In tree boards:

    PandaBoard
    Realview

  Out of tree boards:

    NaviEngine

for the following configurations:

  - SMP, PREEMPT_RT_FULL
  - SMP, PREEMPT_NONE
  - UP, PREEMPT_RT_FULL
  - UP, PREEMPT_NONE

-Frank


