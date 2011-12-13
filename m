Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1LMHpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:45:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47798 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab1LMHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:45:09 -0500
X-Sasl-enc: saXkp6ysWZsh46eIRsXAeG3JNDVzEZRzsx3V3SiXhFUd 1323762308
Date: Mon, 12 Dec 2011 23:44:34 -0800
From: Greg KH <greg@kroah.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 00/24 ] dynamic debug enhancements: multi-queries during
 mod-init
Message-ID: <20111213074434.GC20200@kroah.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
 <20111212220537.GB1641@kroah.com>
 <CAJfuBxzeKzmOCo00Ew8xAp9EmU0QZ3zjOkRcdEMzYrtx_b9+kA@mail.gmail.com>
 <CAJfuBxxgd-w02DP9EBkjTm2cY5e9Us5ArnZy9BGJUcnsAwrhOA@mail.gmail.com>
 <20111213042515.GA18251@kroah.com>
 <CAJfuBxxnT8va7DRt8e7s=LrSqHYThb_8fkbSO69Fii3r1x0hvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfuBxxnT8va7DRt8e7s=LrSqHYThb_8fkbSO69Fii3r1x0hvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 12:00:19AM -0700, Jim Cromie wrote:
> I did use git-send-email.
> What I seem to miss on every send is which reference to use in the
> reply-to part,
> at least when trying to tie it to an email sent from the web-interface.

Don't use the web-interface, it only confuses this type of thing.

good luck,

greg k-h
