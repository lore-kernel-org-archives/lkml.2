Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2EBR2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:28:04 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59357 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab2EBR2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:28:02 -0400
Date: Wed, 2 May 2012 21:27:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: khlebnikov@openvz.org, xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120502172756.GD2301@moon>
References: <1335979380.10666.6.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335979380.10666.6.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 07:23:00PM +0200, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on several lockdep warnings when playing with
> the new files created under /proc/[pid], specifically 'map_files'.
> 
> My theory is that files under map_files shouldn't be executable,
> but since I'm not sure what the usermode code for c/r does exactly,
> I should probably confirm that first. If it's indeed the case, you
> can probably skip the rest of this mail.

Thanks Sasha, I'll take a look!

	Cyrill
