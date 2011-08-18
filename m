Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1HRUJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:09:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51530 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab1HRUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:09:38 -0400
Subject: Re: [PATCH 40/41] ncpfs: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110818170538.GA6910@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-41-git-send-email-matt@console-pimps.org>
	 <20110816175643.GI29190@redhat.com>
	 <1313528170.3436.200.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110817120405.GA10709@redhat.com>
	 <1313589483.2311.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110817144139.GA17271@redhat.com>
	 <CA+i2_De=mKMHj++b5=ZPdXxp7pm2KzY+PzCaG++GWSud20a_qQ@mail.gmail.com>
	 <20110818170538.GA6910@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 21:09:28 +0100
Message-ID: <1313698168.2311.58.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 19:05 +0200, Oleg Nesterov wrote:
> 
> OK. I guess nobody cares. Matt, could you redo your original patch?
> just remove ->siglock and convert it to use set_current_blocked()
> leaving this logic alone.

Sure, will do.

-- 
Matt Fleming, Intel Open Source Technology Center

