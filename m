Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab1KRXN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:13:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab1KRXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:13:55 -0500
Message-ID: <4EC6E67D.4040507@zytor.com>
Date: Fri, 18 Nov 2011 15:13:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        kbuild@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 6/8] x86: Machine-readable syscall tables and scripts
 to process them
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com> <1321569446-20433-7-git-send-email-hpa@linux.intel.com> <20111118221558.GA6408@count0.beaverton.ibm.com>
In-Reply-To: <20111118221558.GA6408@count0.beaverton.ibm.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 02:15 PM, Matt Helsley wrote:
> grep "^[0-9]$my_abis" "$in" | sort -n | (

You mean:

grep -E "^[0-9xX]+[[:space:]]+$my_abis" ...

... I presume?

	-hpa
