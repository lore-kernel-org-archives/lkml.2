Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1A2CQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 21:16:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab1A2CQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 21:16:30 -0500
Message-ID: <4D437875.1040803@redhat.com>
Date: Fri, 28 Jan 2011 21:16:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
References: <1296244340-15173-1-git-send-email-glommer@redhat.com> <1296244340-15173-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 02:52 PM, Glauber Costa wrote:
> Register steal time within KVM. Everytime we sample the steal time
> information, we update a local variable that tells what was the
> last time read. We then account the difference.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
