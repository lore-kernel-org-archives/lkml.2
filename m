Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0IXKom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:44:42 -0400
Received: from www.tglx.de ([62.245.132.106]:45199 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab0IXKol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:44:41 -0400
Date: Fri, 24 Sep 2010 12:45:55 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/5] uio hotplug support
Message-ID: <20100924104555.GC1819@silverbox.local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m139t451b4.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 12:19:59AM -0700, Eric W. Biederman wrote:
> 
> Implement the ability to hotunplug a uio device while file handles
> are still open without crashing.

Could you please create patches that apply on top of your already
accepted UIO changes?

Thanks,
Hans

