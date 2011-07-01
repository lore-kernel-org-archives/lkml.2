Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1GAAZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:25:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59430 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1GAAZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:25:44 -0400
Message-ID: <4E0D1400.7020107@zytor.com>
Date: Thu, 30 Jun 2011 17:25:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Gregory.Dietsche@cuw.edu, tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86, smpboot: Mark names[] array as const
References: <1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu> <tip-a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94@git.kernel.org>
In-Reply-To: <tip-a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 05:21 PM, tip-bot for Greg Dietsche wrote:
> +	const char const *names[] = { "ID", "VERSION", "SPIV" };
        ^^^^^^^^^^^^^^^^

Doesn't make sense, patch removed...
	
	-hpa
