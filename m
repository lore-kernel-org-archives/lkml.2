Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2ERIAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:00:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60053 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2ERIAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120517213120.GA12329@redhat.com>
References: <20120517213120.GA12329@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 18 May 2012 09:59:39 +0200
Message-ID: <CA+1xoqd3=mB83R8DpeAsFpqZ==-W8_q9FSupLJJsOqhKg+TUSg@mail.gmail.com>
Subject: Re: 3.4-rc7 numa_policy slab poison.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
> Just found this while fuzzing.
>
>        Dave
>
> [ 7613.229315] =============================================================================
> [ 7613.229955] BUG numa_policy (Not tainted): Poison overwritten
> [ 7613.230560] -----------------------------------------------------------------------------

I've just hit the same with latest linux-next inside a KVM guest.
