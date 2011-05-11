Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1EKPim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1EKPiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:18 -0400
Message-ID: <4DCA5DA7.9010201@redhat.com>
Date: Wed, 11 May 2011 12:57:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] KVM: make guest mode entry to be rcu quiescent state
References: <1304515864-17105-1-git-send-email-gleb@redhat.com> <1304515864-17105-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1304515864-17105-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 04:31 PM, Gleb Natapov wrote:
> KVM does not hold any references to rcu protected data when it switches
> CPU into a guest mode. In fact switching to a guest mode is very similar
> to exiting to userspase from rcu point of view. In addition CPU may stay
> in a guest mode for quite a long time (up to one time slice). Lets treat
> guest mode as quiescent state, just like we do with user-mode execution.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

