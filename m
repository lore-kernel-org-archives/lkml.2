Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1LMESX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 23:18:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56226 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1LMESU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 23:18:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfuBxzeKzmOCo00Ew8xAp9EmU0QZ3zjOkRcdEMzYrtx_b9+kA@mail.gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <20111212220537.GB1641@kroah.com>
 <CAJfuBxzeKzmOCo00Ew8xAp9EmU0QZ3zjOkRcdEMzYrtx_b9+kA@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 12 Dec 2011 21:17:43 -0700
Message-ID: <CAJfuBxxgd-w02DP9EBkjTm2cY5e9Us5ArnZy9BGJUcnsAwrhOA@mail.gmail.com>
Subject: RE: [patch 00/24 ] dynamic debug enhancements: multi-queries during mod-init
To: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 3:05 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Dec 06, 2011 at 12:11:10PM -0700, jim.cromie@gmail.com wrote:
>> 0001-kernel-module.c-fix-compile-err-warnings-under-ifdef.patch
>> 0002-dynamic_debug-fix-whitespace-complaints-from-scripts.patch
>> 0024-dynamic_debug-remove-unneeded-includes.patch
>>
>
> Now that is just about the most unhelpful 00/XX email I've seen in a
> long time.
>

Sorry about that.
That was an attempt to thread onto a previous message.

In-Reply-To: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>,
<CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>,
<CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>

IE this:

http://article.gmane.org/gmane.linux.kernel/1171277/match=dynamic_debug

I'll use URLs in the future.

> Jason, I'm going to wait for you to test these and forward them on to me
> if you really want me to apply any of them.
>
> greg k-h
