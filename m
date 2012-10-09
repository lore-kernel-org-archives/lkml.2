Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2JIBsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 21:48:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36222 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2JIBsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 21:48:09 -0400
Message-ID: <50738248.7020603@us.ibm.com>
Date: Mon, 08 Oct 2012 18:47:52 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ntp, add debugfs entries for time_status and time_state
References: <1349358521-4386-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1349358521-4386-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100901-2876-0000-0000-000000D7FC2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 06:48 AM, Prarit Bhargava wrote:
> Add debugfs entries for ntp time_status and time_state.  These are useful
> for debugging ntp issues.
Aren't these easily fetched from adjtimex()?  How does having them in 
debugfs help?

thanks
-john

