Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1FLPii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab1FLPih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:38:37 -0400
Message-ID: <4DF4DD64.2020802@redhat.com>
Date: Sun, 12 Jun 2011 18:38:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Brad Campbell <brad@fnarfbargle.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Bart De Schuymer <bdschuym@pandora.be>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <4DED344D.7000005@pandora.be> <4DED9C23.2030408@fnarfbargle.com> <4DEE27DE.7060004@trash.net> <4DEE3859.6070808@fnarfbargle.com> <4DEE4538.1020404@trash.net> <1307471484.3091.43.camel@edumazet-laptop> <4DEEACC3.3030509@trash.net> <4DEEBFC2.4060102@fnarfbargle.com> <1307505541.3102.12.camel@edumazet-laptop> <4DEFAB15.2060905@fnarfbargle.com> <20110610025249.GD643@verge.net.au>
In-Reply-To: <20110610025249.GD643@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 05:52 AM, Simon Horman wrote:
> At one point I would have need an 8000km long wire to the reset switch :-)

Even more off-topic, there has been a case when a 200,000,000 km long 
wire to the reset button was needed.  IIRC they got away with a watchdog.

-- 
error compiling committee.c: too many arguments to function

