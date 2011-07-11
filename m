Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1GKNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:09:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1GKNJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:09:55 -0400
Message-ID: <4E1AF612.7040103@redhat.com>
Date: Mon, 11 Jul 2011 16:09:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Eddie Dong <eddie.dong@intel.com>, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 6/9] add jump labels for ia64 paravirt
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1309793548-16714-7-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 06:32 PM, Glauber Costa wrote:
> Since in a later patch I intend to call jump labels inside
> CONFIG_PARAVIRT, IA64 would fail to compile if they are not
> provided. This patch provides those jump labels for the IA64
> architecture.
>

Please get an ack for this from the ia64 maintainer.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

