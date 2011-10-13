Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1JMPe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:34:28 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:20063
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657Ab1JMPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:34:27 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E9704F9.1090103@freescale.com>
Date: Thu, 13 Oct 2011 10:34:17 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        Jiang Kai-B18973 <B18973@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit
 systems
References: <1318453063-17349-1-git-send-email-galak@kernel.crashing.org> <CAOZdJXWd_u_EWXNhh3-t258+Y8mx=JuJhU93CeZfaocPZvhOFA@mail.gmail.com> <9BD33578-CD8E-4784-AC6A-ADE4614E0FC1@kernel.crashing.org>
In-Reply-To: <9BD33578-CD8E-4784-AC6A-ADE4614E0FC1@kernel.crashing.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
>>> >> +       phys_addr_t             addr;
>> > 
>> > Please add a comment here saying:
>> > 
>> > 1) That 'addr' can be a virtual or physical address
> The code and everything else makes that clear

I'm sorry, but I have to strongly disagree here.  It is *NOT* clear that a
variable of type 'phys_addr_t' can hold something that is not a physical address.

-- 
Timur Tabi
Linux kernel developer at Freescale

