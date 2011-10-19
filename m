Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1JSJMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:12:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:35586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1JSJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:12:22 -0400
Date: Wed, 19 Oct 2011 11:12:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [RFC] [PATCH -rt 5/5] cpufreq: get rid of
 get_online_cpus()/put_online_cpus()
In-Reply-To: <1318762607-2261-6-git-send-email-yong.zhang0@gmail.com>
Message-ID: <alpine.LFD.2.02.1110191110140.3240@ionos>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com> <1318762607-2261-6-git-send-email-yong.zhang0@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011, Yong Zhang wrote:

> Fix below false positive (seems this is not a real deadlock scenario)
> lockdep warning:

This looks like you caused it with patch 1. Both need a bit more
thought, but thanks for catching that.

Thanks,

	tglx
