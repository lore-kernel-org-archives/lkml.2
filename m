Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2HPN3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:29:47 -0400
Received: from natasha.panasas.com ([67.152.220.90]:37236 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2HPN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:29:45 -0400
Message-ID: <502CF5A2.6000902@panasas.com>
Date: Thu, 16 Aug 2012 16:29:06 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Marco Stornelli <marco.stornelli@gmail.com>, <bhalevy@tonian.com>,
        <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>, <tytso@mit.edu>,
        <hirofumi@mail.parknet.co.jp>, <mikulas@artax.karlin.mff.cuni.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, <hch@infradead.org>,
        <dushistov@mail.ru>, <osd-dev@open-osd.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
References: <502CC4AA.6040702@gmail.com>   <1345119652.3393.220.camel@sauron.fi.intel.com>   <502CE840.4060802@panasas.com>  <1345122611.3393.225.camel@sauron.fi.intel.com>  <502CF259.9040300@panasas.com> <1345123814.3393.237.camel@sauron.fi.intel.com>
In-Reply-To: <1345123814.3393.237.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 04:30 PM, Artem Bityutskiy wrote:

> On Thu, 2012-08-16 at 16:15 +0300, Boaz Harrosh wrote:
>> There are some optimizations I can do here, but lets for now just do
>> the sb->s_lock thing, and I might decide to completely revamp the
>> all thing later. 
> 
> OK. But I guess an exofs-specific mutex could be used instead. We do not
> have to depend on 'sb->s_lock'.
> 


sorry I meant sbi->s_lock. But I'm fine with the complete drop now

Thanks
Boaz

