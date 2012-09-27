Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2I0DPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:15:05 -0400
Received: from ozlabs.org ([203.10.76.45]:60326 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab2I0DPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:15:02 -0400
Date: Thu, 27 Sep 2012 13:14:44 +1000
From: Paul Mackerras <paulus@samba.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6][RFC] time: Convert CONFIG_GENERIC_TIME_VSYSCALL to
 CONFIG_GENERIC_TIME_VSYSCALL_OLD
Message-ID: <20120927031444.GB14959@drongo>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <1347919501-64534-4-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347919501-64534-4-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 06:04:58PM -0400, John Stultz wrote:
> To help migrate archtectures over to the new update_vsyscall method,
> redfine CONFIG_GENERIC_TIME_VSYSCALL as CONFIG_GENERIC_TIME_VSYSCALL_OLD
> 
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: Paul Mackerras <paulus@samba.org>
