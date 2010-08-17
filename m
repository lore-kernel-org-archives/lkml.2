Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0HQJIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab0HQJIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:08:09 -0400
Message-ID: <4C6A5171.2060408@redhat.com>
Date: Tue, 17 Aug 2010 12:08:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: explain 'no-kvmclock' kernel parameter
References: <alpine.LNX.2.00.1008161751070.1019@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1008161751070.1019@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/16/2010 06:51 PM, Jiri Kosina wrote:
> no-kvmclock kernel parameter is missing its explanation in
> Documentation/kernel-parameters.txt. Add it.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

