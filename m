Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0G1UPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0G1UPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:15:50 -0400
Date: Wed, 28 Jul 2010 16:14:59 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 00/12] jump label v10
Message-ID: <20100728201459.GA28992@redhat.com>
References: <cover.1280263065.git.jbaron@redhat.com> <20100728.123427.63008085.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728.123427.63008085.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 12:34:27PM -0700, David Miller wrote:
> Can you please indicate which tree this is against when you post these
> patches?
> 
> They don't apply cleanly to Linus's current tree which is where I tend
> to try first when the tree is unspecified, as I imagine others do as
> well.
> 

Hi,

Patches are against Ingo's latest -tip tree. 

thanks,

-Jason
