Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1H3Map (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:30:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42352 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1H3Mao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110829205424.GA18208@redhat.com>
References: <20110826214930.GA21818@redhat.com>
	<20110829204830.GA18543@redhat.com>
	<20110829205424.GA18208@redhat.com>
Date: Tue, 30 Aug 2011 08:30:43 -0400
Message-ID: <CA+5PVA786GVOQdwkRGW5daQdaAATXR0-ZBbbYVUa3S5B27Andg@mail.gmail.com>
Subject: Re: ext4 lockdep trace (3.1.0rc3)
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        tytso@mit.edu, adilger.kernel@dilger.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 4:54 PM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Aug 29, 2011 at 04:48:30PM -0400, Dave Jones wrote:
>  > On Fri, Aug 26, 2011 at 05:49:30PM -0400, Dave Jones wrote:
>  >  > just hit this while building a kernel.  Laptop wedged for a few seconds
>  >  > during the final link, and this was in the log when it unwedged.
>  >
>  > I still see this in rc4, and can reproduce it reliably every time I build.
>  > It only started happening in the last week.  I don't see any ext4 or vfs commits
>  > within a few days of that, so I'm not sure why it only just begun
>  > (I do daily builds, and the 26th was the first time I saw it appear)
>  >
>  > Given the lack of obvious commits in that timeframe, I'm not sure a bisect is
>  > going to be particularly fruitful. It might just be that my IO patterns changed ?
>
> also a second variant with a different trace.

That one has been reported for a while.  See RH bug 732572

josh
