Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1JMNx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:53:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63273 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1JMNx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:53:28 -0400
MIME-Version: 1.0
In-Reply-To: <20111014003341.36bd655d41bf31804d720174@canb.auug.org.au>
References: <20111013174358.b20fedb97c7b53db2ba82ff6@canb.auug.org.au>
	<CAPM=9tyuHeKgrh6iyJVUKF3rdy8-izwSJuJRBwCOSsz4DDsccQ@mail.gmail.com>
	<20111014003341.36bd655d41bf31804d720174@canb.auug.org.au>
Date: Thu, 13 Oct 2011 14:53:27 +0100
Message-ID: <CAPM=9tyWaL=ySxs=Zgfdde8Um4JbsB2Nem8Rsfaq7voLBv+Pqg@mail.gmail.com>
Subject: Re: currently missing kernel devel trees
From: Dave Airlie <airlied@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 2:33 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
>
> On Thu, 13 Oct 2011 13:36:01 +0100 Dave Airlie <airlied@gmail.com> wrote:
>>
>> > drm
>> > agp
>>
>> git://people.freedesktop.org/~airlied/linux.git drm-next
>
> OK, I will switch to that.   What should I do about the agp tree. It just
> has three commits that are also in Linus' tree (as different commits).
>

drop it, I've pretty much pushed agp via drm tree now.

Dave.
