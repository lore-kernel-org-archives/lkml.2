Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0LMBl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:41:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab0LMBl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <201012130128.31243.rjw@sisk.pl>
References: <201012130128.31243.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 12 Dec 2010 17:35:41 -0800
Message-ID: <AANLkTimKALTwMF4KD=aaW76r5+_xR9SoZGUPaM+YfmUd@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/4] PM: Use separate lists of devices at each stage
 of suspend/resume
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 4:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Please let me know what you think.

All looks A-ok to me, with the small simplification suggestion posted
separately.

          Linus
