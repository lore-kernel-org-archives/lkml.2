Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2C0MNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:13:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41716 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2C0MNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:13:34 -0400
Message-ID: <4F71AE95.9080600@mvista.com>
Date: Tue, 27 Mar 2012 16:12:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] amba-pl011: fix panic introduced by "clear pending interrupts"
References: <20120326203209.GA8182@mail.gnudd.com>
In-Reply-To: <20120326203209.GA8182@mail.gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-03-2012 0:32, Alessandro Rubini wrote:

> patch 9b96fba, currently in linux-next, clears interrupts using

    Please also specify the summary of this commit in parens.

> uap->port.membase that has not been assigned.  My x86 system,
> that uses a pci-to-amba bridge, panics with a message like:

>     BUG: unable to handle kernel NULL pointer dereference at 00000038
>     IP: [<c12c85ed>] pl011_probe+0x119/0x303

> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>

WBR, Sergei
