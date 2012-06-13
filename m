Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2FMGNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2FMGNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:13:35 -0400
Message-ID: <4FD82F89.80106@redhat.com>
Date: Wed, 13 Jun 2012 08:13:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com> <20120613013549.GO22848@dastard> <20120613033052.GT22848@dastard>
In-Reply-To: <20120613033052.GT22848@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/06/2012 05:30, Dave Chinner ha scritto:
>> > 
>> > Also, a minor nit, but you should credit where this code has
>> > originated from in the commit messages, and describe the use case
>> > for requiring it. i.e. based on:
>> > 
>> > http://permalink.gmane.org/gmane.linux.file-systems/62449

Interesting, I didn't know this---I wrote the code from scratch.

I took the description from the man pages ("This operation is a fast
method of overwriting any from the range specified with zeros without
removing any blocks or having to write zeros to disk"), so perhaps those
will have to be patched as well.

> Oh, and you'll need to provide a new xfstests test based on 242 that
> uses the new fallocate interface, and to do that you'll also need to
> add support for the new fallocate function in xfs_io.

Sure.  Thanks for the hints, I'll submit a v2 (may take a while as I'll
leave for holiday soon).

Paolo
