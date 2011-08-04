Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1HDGpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:45:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61458 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1HDGpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110803223407.GA20646@redhat.com>
References: <20110803223407.GA20646@redhat.com>
Date: Thu, 4 Aug 2011 14:45:01 +0800
Message-ID: <CAC=cRTM_CZfstvbpdCRrLV-VH0VC=u6r10L+Ox2G4LWomXVauA@mail.gmail.com>
Subject: Re: [rfc] suppress excessive AER output
From: huang ying <huang.ying.caritas@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        tom.l.nguyen@intel.com, yanmin.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 6:34 AM, Dave Jones <davej@redhat.com> wrote:
> I have a machine that has developed some kind of problem with
> its onboard ethernet.  It still boots, but spewed almost 1.5G of text
> (2381585 instances of the warning below) before we realised what
> was going on, and blacklisted the igb driver.
>
> Is it worth logging every single error when we're flooding like this ?
> It seems unlikely that we'll find useful information in amongst that much data
> that wasn't already in the first 100 instances.
>
> I picked 100 in the (untested) example patch below arbitarily, but the exact
> value could be smaller, or slightly bigger..
>
> could we do something like this maybe ?

Why not use __ratelimit to implement this feature?

Best Regards,
Huang Ying
