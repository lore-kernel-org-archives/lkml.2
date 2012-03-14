Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab2CNJoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:44:37 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:41016
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab2CNJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:44:35 -0400
Message-ID: <4F6050E8.1060100@akkadia.org>
Date: Wed, 14 Mar 2012 04:03:52 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: arnd@arndb.de, davem@davemloft.net, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: [PATCH] Install kernel-page-flags.h
References: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com> <20120314075842.GA337@infradead.org>
In-Reply-To: <20120314075842.GA337@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 03:58 AM, Christoph Hellwig wrote:
> I don't think this is a good idea at all.  Let's shoot the person who
> added that braindead interface ASAP, and replace it with one printing
> the flags in ASCII format.

This isn't really realistic.  The information is retrieved based on the 
PFN using lseek+read from a file descriptor.  How is the read supposed 
to work in case the record returned is not of a fixed size?  Aside, 
potentially a lot of these records are to be read and using ASCII 
strings will significantly slow things down.

If you have a concrete proposal please go ahead and propose it.
