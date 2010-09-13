Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0IMUC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:02:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60771 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab0IMUCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:02:24 -0400
Message-ID: <4C8E82F9.3080805@zytor.com>
Date: Mon, 13 Sep 2010 13:00:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
References: <1284366708-30154-1-git-send-email-florian@mickler.org>	<1284367195.2275.29.camel@laptop>	<4C8E49B7.7040104@zytor.com>	<20100913182105.7463dd99@schatten.dmk.lab>	<20100913182838.70aa0964@schatten.dmk.lab>	<4C8E5E97.6070908@zytor.com> <20100913204244.55524e22@schatten.dmk.lab>
In-Reply-To: <20100913204244.55524e22@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 11:42 AM, Florian Mickler wrote:
> 
> I can imagine that even without having expirienced anything alike :) 
> 
> Should I then resend this RFC-Patch updated to abort the x86-build for
> gcc -lt 3.4?
> 

I'm doing a patch series which is a little more complete; I'll post it
shortly.

	-hpa
