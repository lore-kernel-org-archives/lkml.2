Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2A3JP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:15:56 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:50938 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2A3JPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:15:54 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 04:15:54 EST
Message-ID: <4F265E74.4040602@Calva.COM>
Date: Mon, 30 Jan 2012 10:10:12 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: John Hughes <john@calvaedi.com>, Jonathan Nieder <jrnieder@gmail.com>,
        John Hughes <john@atlantech.com>,
        Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [Sony Vaio TX3] TPM chip prevents machine from suspending a second
 time
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20120121170157.GA18053@burratino> <4F1DC8A3.60901@linux.vnet.ibm.com> <4F252441.3090507@calvaedi.com> <4F258E4C.8020606@linux.vnet.ibm.com>
In-Reply-To: <4F258E4C.8020606@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/12 19:22, Stefan Berger wrote:
> On 01/29/2012 05:49 AM, John Hughes wrote:
>>
> Thanks. Please try the attached patch.
>
> I am not sure whether this is the right way to go, though: Is it a 
> problem particular to this BIOS + Board or a general problem of this 
> BIOS? Is it specific to the TX3 or to all VAIOs?

I'll try the patch.

As to your questions about its applicability I'm afraid I can shed no 
light.  I can't even update the Bios to the latest version for the 
moment as the bios updater needs windows. :-(

