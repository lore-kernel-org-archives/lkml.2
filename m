Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0HGEJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:09:21 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59097 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0HGEJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:09:18 -0400
Date: Sat, 7 Aug 2010 06:09:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KCONFIG savedefconfig
Message-ID: <20100807040916.GB30520@merkur.ravnborg.org>
References: <alpine.DEB.2.00.1008062024320.30564@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008062024320.30564@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 08:25:43PM -0700, david@lang.hm wrote:
> when savedefconfig decides what to write out, what does it do for things  
> that are not at the default, but were set to not be default as part of  
> dependancy resolution?

The short version:
Any symbol that does not have default value are written to
the defconfig file.

Using the defconfig file as input or using the full config file
as input shall result in the same configuration.
If not you found a bug we need to fix.

Arve found one bug I have to look into - pending feedback.
And I have found one bug related to tristate choice values.

So a bit work is needed to make it ready :-(
But it works for most of the defconfig we have today.

	Sam
