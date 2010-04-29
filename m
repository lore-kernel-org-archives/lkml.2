Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0D2ARj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:17:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55430 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0D2ARi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:17:38 -0400
Message-ID: <4BD8D015.6000703@zytor.com>
Date: Wed, 28 Apr 2010 17:17:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: reduce SMP locks table size
References: <4BCF30FE020000780003B3B6@vpn.id2.novell.com>
In-Reply-To: <4BCF30FE020000780003B3B6@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 08:08 AM, Jan Beulich wrote:
> ... by using relative pointers instead of absolute ones, thus cutting
> the table size by half.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

We probably could use something like this for the alternatives and
exceptions tables, too...

	-hpa
