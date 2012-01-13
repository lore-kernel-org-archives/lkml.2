Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2AMOVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:21:11 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3830 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204Ab2AMOVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:21:10 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4F103DBD.4070704@broadcom.com>
Date: Fri, 13 Jan 2012 15:20:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20120113@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: brcmsmac: 3.2.0-06100: no device shown (and hangs in
 3.2.0-rc7)
References: <20120113124559.GA2260@schottelius.org>
 <4F103379.2050904@broadcom.com> <20120113141809.GA3072@schottelius.org>
In-Reply-To: <20120113141809.GA3072@schottelius.org>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 630EE0623DS15356792-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 03:18 PM, Nico Schottelius wrote:
> Hey Arend,
> 
> Arend van Spriel [Fri, Jan 13, 2012 at 02:36:57PM +0100]:
>> Could this be on your MacBook Air? If so, Linus has flagged and solved
>> this issue (see thread "brcm80211 breakage" on netdev mailer).
> 
> Oh, yes, indeed!
> 
> Although the channel 13 issue seems still to exist.

Likely. I did not dive into that issue yet.

> I'll apply his patches this evening and test as well.
> 
> Cheers,
> 
> Nico
> 

Gr. AvS

