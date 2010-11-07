Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0KGVl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:41:58 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:34565 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0KGVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:41:57 -0500
Message-ID: <4CD71DB4.7050608@cs.columbia.edu>
Date: Sun, 07 Nov 2010 16:44:20 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu>
In-Reply-To: <20101106204008.GA31077@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux containers mailing list]

On 11/06/2010 04:40 PM, Gene Cooperman wrote:

> 8.  What happens if the DMTCP coordinator ( checkpoint control process) dies?
>    [ The same thing that happens if a user process dies.  We kill the whole
>      computation, and restart.  At restart, we use a new coordinator.
>      Coordinators are stateless. ]

My experience is different:

I downloaded dmtcp and followed the quick-start guide:
(1) "dmtcp_coordinator" on one terminal
(2) "dmtcp_checkpoint bash" on another terminal

Then I:
(3) pkill -9 dmtcp_coordinator
... oops - 'bash' died.

I didn't even try to take a checkpoint :(

Oren.
