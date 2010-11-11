Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0KKQcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0KKQcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:32:08 -0500
Message-ID: <4CDC1A5F.9050803@redhat.com>
Date: Thu, 11 Nov 2010 11:31:27 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        esandeen@redhat.com, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
References: <20101109114422.3918e7f6@annuminas.surriel.com> <20101109142109.224267d0@corrin.poochiereds.net> <4CD9A209.6070807@redhat.com> <20101109210715.GJ3099@thunk.org>
In-Reply-To: <20101109210715.GJ3099@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 04:07 PM, Ted Ts'o wrote:

> Do we guarantee that the application will get EIO at least once?  I
> thought there were issues where the error bit could get lost if the
> page writeback was triggered by sync() run by a third-party
> application.

Andrew, both the current kernel before and after my patch does
not guarantee the behaviour Ted has pointed out is required.

Johannes came up with a way to guarantee that - I'll send in
a patch for that today.  That patch will obsolete the patch
I sent before (I don't think you've applied it yet).

-- 
All rights reversed
