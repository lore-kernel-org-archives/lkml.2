Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2HRAn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 20:43:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2HRAnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 20:43:49 -0400
MIME-Version: 1.0
In-Reply-To: <201208180002.26563.rjw@sisk.pl>
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
	<1345212420-1707-3-git-send-email-ming.lei@canonical.com>
	<201208180002.26563.rjw@sisk.pl>
Date: Sat, 18 Aug 2012 08:43:48 +0800
Message-ID: <CACVXFVNVvponQD85o4RHxF9e+JRtq-AX5kZOuxvETDSGktit5A@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] PM / Sleep: introduce dpm_for_each_dev
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 17, 2012, Ming Lei wrote:
>> +void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *))
>
> Is this function actually used more than once?

At least now, it is called each time before system sleep.


Thanks,
--
Ming Lei
