Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1LMEZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 23:25:24 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45192 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab1LMEZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 23:25:21 -0500
X-Sasl-enc: l/px/K8neNFCDXCHtNCUxDUgkUB6Fngt6ViDIe7Xe8ji 1323750320
Date: Mon, 12 Dec 2011 20:25:15 -0800
From: Greg KH <greg@kroah.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 00/24 ] dynamic debug enhancements: multi-queries during
 mod-init
Message-ID: <20111213042515.GA18251@kroah.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
 <20111212220537.GB1641@kroah.com>
 <CAJfuBxzeKzmOCo00Ew8xAp9EmU0QZ3zjOkRcdEMzYrtx_b9+kA@mail.gmail.com>
 <CAJfuBxxgd-w02DP9EBkjTm2cY5e9Us5ArnZy9BGJUcnsAwrhOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfuBxxgd-w02DP9EBkjTm2cY5e9Us5ArnZy9BGJUcnsAwrhOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:17:43PM -0700, Jim Cromie wrote:
> On Mon, Dec 12, 2011 at 3:05 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Dec 06, 2011 at 12:11:10PM -0700, jim.cromie@gmail.com wrote:
> >> 0001-kernel-module.c-fix-compile-err-warnings-under-ifdef.patch
> >> 0002-dynamic_debug-fix-whitespace-complaints-from-scripts.patch
> >> 0024-dynamic_debug-remove-unneeded-includes.patch
> >>
> >
> > Now that is just about the most unhelpful 00/XX email I've seen in a
> > long time.
> >
> 
> Sorry about that.
> That was an attempt to thread onto a previous message.
> 
> In-Reply-To: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>,
> <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
> References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>,
> <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
> 
> IE this:
> 
> http://article.gmane.org/gmane.linux.kernel/1171277/match=dynamic_debug
> 
> I'll use URLs in the future.

Use git-send-email and you will not have to do any of this by hand, it
handles it all for you automatically.

greg k-h
