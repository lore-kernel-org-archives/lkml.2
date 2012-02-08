Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2BHVBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:01:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61219 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2BHVBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:01:40 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.244.225]
In-Reply-To: <20120131200945.GD22611@ponder.secretlab.ca>
References: <1328028762-28352-1-git-send-email-ohad@wizery.com> <20120131200945.GD22611@ponder.secretlab.ca>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 8 Feb 2012 23:01:19 +0200
Message-ID: <CAK=WgbaHE4poc7jxhqc9EEYtbpRqDoC87jMGpS6=OJNZJfe9Qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: bail out if firmware has different endianess
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Grosen <mgrosen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:09 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Tue, Jan 31, 2012 at 06:52:41PM +0200, Ohad Ben-Cohen wrote:
>> At this point we don't support remote processors that have
>> a different endianess than the host.
>>
>> Look out for these unsupported scenarios, and bail out if
>> encountered.
>>
>> Reported-by: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
>> Cc: Mark Grosen <mgrosen@ti.com>
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks, applied both patches to remoteproc's for-next.
