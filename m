Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1JSOqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:46:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39655 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1JSOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:46:31 -0400
Message-ID: <1319035584.8416.34.camel@edumazet-laptop>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: Arend van Spriel <arend@broadcom.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Wed, 19 Oct 2011 16:46:24 +0200
In-Reply-To: <20111019142837.GA1414@schottelius.org>
References: <20111019123602.GA11883@schottelius.org>
	 <1319028563.8416.1.camel@edumazet-laptop>
	 <20111019130749.GD11883@schottelius.org>
	 <20111019142837.GA1414@schottelius.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 octobre 2011 à 16:28 +0200, Nico Schottelius a écrit :
> Triggered it! 
> 
> And also got the traceback!
> 
> Dmesg + log attached, let me know when I can pull the fix from
> somewhere.
> 

Sorry, I cant see same messages in your dmesg, no mention of stuck
processes (blocked for more than 120 seconds.)

By the way, please update to latest 3.1.rc10



