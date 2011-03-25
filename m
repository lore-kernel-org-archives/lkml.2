Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab1CYIfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:35:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:35333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346Ab1CYIfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:35:03 -0400
Date: Fri, 25 Mar 2011 09:34:59 +0100
From: Libor Pechacek <lpechacek@suse.cz>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: remove dead code from usb_deregister_dev()
Message-ID: <20110325083458.GB30773@fm.suse.cz>
References: <20110324132426.GA27561@fm.suse.cz> <4D8B48D2.1050704@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B48D2.1050704@ru.mvista.com>
User-Agent: Mutt/1.5.18-muttng (2008-05-17-r1399)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-03-11 16:36:18, Sergei Shtylyov wrote:
> On 24-03-2011 16:24, Libor Pechacek wrote:
>> The `name' variable is unused in usb_deregister_dev() since commit d6e5bcf.
>
>    Please also specify that commit's summary in parens for the human 
> readers,

OK, sounds sane.  Updated patch will follow.

> as asked by Linus.

Can you please post a reference to the thread?  I'd like to read it but can't
find it.

Libor
-- 
Libor Pechacek
SUSE L3 Team, Prague
