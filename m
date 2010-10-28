Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0J1W0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:26:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36003 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649Ab0J1W0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:26:33 -0400
Message-ID: <4CC9F854.4000404@zytor.com>
Date: Thu, 28 Oct 2010 15:25:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Brian Gerst <brgerst@gmail.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, x86@kernel.org
Subject: Re: [PATCH v2] preempt: fix kernel build with !CONFIG_BKL
References: <20101028095910.GA15970@shutemov.name> <201010281612.33732.arnd@arndb.de> <20101028194703.GA19183@shutemov.name> <201010282308.55941.arnd@arndb.de>
In-Reply-To: <201010282308.55941.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 02:08 PM, Arnd Bergmann wrote:
>>
>> Hm... You are right. But this wasn't a problem before (see git log).
>> Let's leave it with quotes.
> 
> Git doesn't care. Only if someone uses a tool to extract email addresses
> out of git and send you a message, it may confuse the email system.
>  

The quotes get inserted by some email systems to prevent *other* email
systems from being confused.

	-hpa
