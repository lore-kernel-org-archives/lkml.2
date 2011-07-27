Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1G0Slk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:41:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44780 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab1G0Slh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:41:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-rP+s7QgObFfudiM9wsVjfXVrVeWs9-OtTsp70rX-te+Q@mail.gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-22-git-send-email-jim.cromie@gmail.com> <CAO+b5-rP+s7QgObFfudiM9wsVjfXVrVeWs9-OtTsp70rX-te+Q@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 27 Jul 2011 12:41:06 -0600
Message-ID: <CAJfuBxwYxZ0FJNoZPkw3TH2yPLZMGNL0Mby7UHXwrgCJu52RfA@mail.gmail.com>
Subject: Re: [PATCH 21/25] dynamic_debug: shrink struct pending query to size
 actually needed
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:32 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> -       pr_debug("query saved as pending %d\n", pending_ct);
>> +       pr_debug("query saved as pending %d, in %d+%d bytes\n",
>> +               pending_ct, sizeof(struct pending_query), buflen);
>
> The proper format specifier for size_t is %zd, not %d. Does this mean
> that this code has not yet been compiled on a 64-bit system ?
>
> Bart.
>

this patch hadnt been compiled on 64,
it has been now, and updated to my github repo,
not resending it or others now, awaiting further comments.
