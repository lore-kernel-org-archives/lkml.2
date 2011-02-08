Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1BHToR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:44:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:26453 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1BHToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:44:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="655728058"
Message-ID: <45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
In-Reply-To: <20110208193857.GA8839@infradead.org>
References: <james_p_freyensee@linux.intel.com>
    <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
    <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
    <20110208193857.GA8839@infradead.org>
Date: Tue, 8 Feb 2011 11:44:16 -0800 (PST)
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
From: james_p_freyensee@linux.intel.com
To: "Christoph Hellwig" <hch@infradead.org>
Cc: james_p_freyensee@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 08, 2011 at 11:34:46AM -0800,
> james_p_freyensee@linux.intel.com wrote:
>> From: J Freyensee <james_p_freyensee@linux.intel.com>
>>
>> This allows drivers who call this function to be compiled modularly.
>> Otherwise, a driver who is interested in this type of functionality
>> has to implement their own.
>
> NAK.
>
> From current you can just dereference current->comm, and access from
> other threads from drivers is a bad idea.
>
>

That is originally what I did, but after talking with Greg KH, Arjan vdv,
and Alan Cox I made this patch instead.

