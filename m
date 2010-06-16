Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab0FPLrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0FPLrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:47:10 -0400
Message-ID: <4C18B9AC.3070409@redhat.com>
Date: Wed, 16 Jun 2010 14:46:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <20100616113253.24017.qmail@science.horizon.com>
In-Reply-To: <20100616113253.24017.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 02:32 PM, George Spelvin wrote:
>
> (An halfway version of this optimization whoch sould avoid the need for
> an IPI would be *save* the FPU state, but mark it "clean", so the re-load
> can be skipped if we're lucky.  If the code supported this as well as the
> IPI alternative, you could make a heuristic guess at switch-out time
> whether to save immediately or hope the odds of needing the IPI are less than
> the fxsave/IPI cost ratio.)
>    

That's an interesting optimization - and we already have something 
similar in the form of fpu preload.  Shouldn't be too hard to do.

-- 
error compiling committee.c: too many arguments to function

