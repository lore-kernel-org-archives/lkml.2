Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1LMHAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:00:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64904 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1LMHAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111213042515.GA18251@kroah.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <20111212220537.GB1641@kroah.com>
 <CAJfuBxzeKzmOCo00Ew8xAp9EmU0QZ3zjOkRcdEMzYrtx_b9+kA@mail.gmail.com>
 <CAJfuBxxgd-w02DP9EBkjTm2cY5e9Us5ArnZy9BGJUcnsAwrhOA@mail.gmail.com> <20111213042515.GA18251@kroah.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 13 Dec 2011 00:00:19 -0700
Message-ID: <CAJfuBxxnT8va7DRt8e7s=LrSqHYThb_8fkbSO69Fii3r1x0hvg@mail.gmail.com>
Subject: Re: [patch 00/24 ] dynamic debug enhancements: multi-queries during mod-init
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 9:25 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Dec 12, 2011 at 09:17:43PM -0700, Jim Cromie wrote:
>> On Mon, Dec 12, 2011 at 3:05 PM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Dec 06, 2011 at 12:11:10PM -0700, jim.cromie@gmail.com wrote:
>> >> 0001-kernel-module.c-fix-compile-err-warnings-under-ifdef.patch
>> >> 0002-dynamic_debug-fix-whitespace-complaints-from-scripts.patch
>> >> 0024-dynamic_debug-remove-unneeded-includes.patch
>> >>
>> >
>> > Now that is just about the most unhelpful 00/XX email I've seen in a
>> > long time.
>> >
>>
>> Sorry about that.
>> That was an attempt to thread onto a previous message.
>>
>> In-Reply-To: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>,
>> <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
>> References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>,
>> <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
>>
>> IE this:
>>
>> http://article.gmane.org/gmane.linux.kernel/1171277/match=dynamic_debug
>>
>> I'll use URLs in the future.
>
> Use git-send-email and you will not have to do any of this by hand, it
> handles it all for you automatically.
>
> greg k-h


I did use git-send-email.
What I seem to miss on every send is which reference to use in the
reply-to part,
at least when trying to tie it to an email sent from the web-interface.
It doesnt help that gmail isnt displaying them in a thread for me
using the headers that git-send-email is adding (it threads by subject)

(for most recent batch..)
Message-Id: <1323731569-20644-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>

On previous batch (the one you commented on), IIRC, I deleted all
--compose content
after realizing the patch-count was wrong, thinking it would behave like
a rebase -i with an empty to-do file.  Or, it was some other operator error.

Looking now at the headers, I'll trust that --compose will work the same,
and use that only (should the latest set need another resend)

thanks
Jim
