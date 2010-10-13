Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab0JMQIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:08:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab0JMQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:08:00 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        arndb@arndb.de
Subject: Re: A question about ZONE_DMA
References: <20101013145240.GE12467@foucault.redhat.com>
	<20101013151247.GF12467@foucault.redhat.com>
Date: Wed, 13 Oct 2010 18:07:55 +0200
In-Reply-To: <20101013151247.GF12467@foucault.redhat.com> (Casey Dahlin's
	message of "Wed, 13 Oct 2010 11:12:48 -0400")
Message-ID: <87mxqiaxes.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin <cdahlin@redhat.com> writes:

> Thanks for the quick replies. My youth affords me the luxury of not knowing
> much about floppy drives or parports :). All makes sense now.

In addition it is used as fallback for all kinds of other DMA which is
less than 32bits. e.g. there used to be popular systems with 31 or 29
bits addressing capability.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
