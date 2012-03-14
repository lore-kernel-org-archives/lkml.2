Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2CNMwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:52:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54936 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab2CNMwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:52:16 -0400
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RT 0/7] [ANNOUNCE] 3.0.23-rt40-rc1
Date: Wed, 14 Mar 2012 13:52:09 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-106.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
References: <20120314022658.783312660@goodmis.org>
In-Reply-To: <20120314022658.783312660@goodmis.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203141352.10145.fzuuzf@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 14 März 2012 schrieb Steven Rostedt:


> Changes from 3.0.23-rt39:
> 
> ---
> 
> 
> Steven Rostedt (2):
>       Revert "ACPI: Convert embedded controller lock to raw spinlock"
>       Linux 3.0.23-rt40-rc1


How about also reverting the commit that has changed acpi_gbl_gpe_lock to a
raw spinlock?

Thanks,
Karsten
