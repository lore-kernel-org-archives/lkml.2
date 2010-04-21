Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0DUR52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:57:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40034 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab0DUR51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:57:27 -0400
Message-ID: <4BCF3C5E.5000103@zytor.com>
Date: Wed, 21 Apr 2010 10:56:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce and use percpu_inc()
References: <4BCF261F020000780003B33C@vpn.id2.novell.com>
In-Reply-To: <4BCF261F020000780003B33C@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 07:21 AM, Jan Beulich wrote:
> ... generating slightly smaller code.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

How much smaller?  Keep in mind that although INC is smaller than ADD,
the former has flag dependencies that the latter doesn't...

	-hpa
