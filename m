Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2CaVM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:12:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53907 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752844Ab2CaVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:12:24 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/0y0IvWIj0T+lUGfIwyXgyxHZxT7mlmrEN2mRQv3
	OOdfV1Yh9QeH2i
Message-ID: <4F777316.9090406@gmx.de>
Date: Sat, 31 Mar 2012 21:11:50 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Wang YanQing <udknight@gmail.com>
Subject: Re: [ 086/149] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
References: <20120330194853.145065448@linuxfoundation.org>	<4F76260C.7080005@gmx.de>	<20120331180317.GA10792@kroah.com> <20120331213738.57a9649d@pyramind.ukuu.org.uk>
In-Reply-To: <20120331213738.57a9649d@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 08:37 PM, Alan Cox wrote:
> On Sat, 31 Mar 2012 11:03:17 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>> On Fri, Mar 30, 2012 at 09:30:52PM +0000, Florian Tobias Schandinat wrote:
>>> Hi Greg,
>>>
>>> On 03/30/2012 07:49 PM, Greg KH wrote:
>>>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> the same as for 3.3: This patch would require exporting
>>> 'pcibios_enabled' to not break building uvesafb as a module. As Alan did
>>> not agree with this approach it is not suitable for stable as is.
>>
>> Oops, sorry about that, now removed, thanks for letting me know.
> 
> Actually for the backport its probably the right thing to do - its
> simple, clear and slightly ugly, but its fairly provably safe.

Is there a problem with using your preferred solution
"__supported_pte_mask & _PAGE_NX" here?
As far as I can see it should work since 2008.


Best regards,

Florian Tobias Schandinat
