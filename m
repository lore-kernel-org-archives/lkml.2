Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2DBVva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:51:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2DBVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:51:29 -0400
Message-ID: <4F7A1F52.50706@kernel.dk>
Date: Mon, 02 Apr 2012 14:51:14 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file handling
References: <1332975091-10950-1-git-send-email-tj@kernel.org> <4F741AED.6090901@kernel.dk> <20120402200233.GB17175@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120402200233.GB17175@dhcp-172-17-108-109.mtv.corp.google.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-02 13:02, Tejun Heo wrote:
> Hey, Jens.
> 
> On Thu, Mar 29, 2012 at 10:18:53AM +0200, Jens Axboe wrote:
>> The diffstat is very tasty... I'll leave this on out until the cgroup
>> merge mess is settled, though.
> 
> The following branch contains this patchset on top of the current
> block/for-3.5/core 959d851caa "Merge branch 'for-3.5' of ../cgroup
> into block/for-3.5/core-merged".
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-files
> 
> Other than $SUBJ update on the eigth patch from "blkcg:
> blkg_conf_prep()" to "blkcg: simplify blkg_conf_prep()", the patchset
> can be applied as-is on top of the current block/for-3.5/core.

Alright, pulled in as well. I'm glad we pushed this to 3.5 :-)

-- 
Jens Axboe

