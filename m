Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1LHXLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:11:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33444 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1LHXLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:11:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111209085740.a23a0295a5ea15ab51169f3c@canb.auug.org.au>
References: <CAB=NE6XDHL8mexe49TSoug3COh11RAvVY339Ntj0MJdw96wO1w@mail.gmail.com>
 <20111209085740.a23a0295a5ea15ab51169f3c@canb.auug.org.au>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 8 Dec 2011 15:11:15 -0800
X-Google-Sender-Auth: 3wF3BYD6ESuJ0Hcj-Zqg6UQ29-Q
Message-ID: <CAB=NE6X4rgcHWUwn0fRkurf2Y5ci=eERQkNiN=UrPakECYKNdw@mail.gmail.com>
Subject: Re: linux-next base Linus tag
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dani Keerikoolparn <danik@qca.qualcomm.com>,
        "Hoefel, Guilherme" <hoefel@qualcomm.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 1:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Luis,
>
> On Thu, 8 Dec 2011 13:39:16 -0800 "Luis R. Rodriguez" <mcgrof@frijolero.org> wrote:
>>
>> If I know a linux-next tag, say next-20110928, how can I extract the
>> Linus tag you used to start that set of merges for linux-next for?
>> That is, I am assuming you base your daily linux-next merges on that
>> day's latest Linus's rc cycle (not just Linus's master tag of that
>> day). Is that right? If so how can I get that tag?
>
> In each linux-next, there is a file called Next/SHA1s, and in there is a
> SHA1 for "origin" - that is the point in Linus' tree that I started for
> that day.  I just use the latest available version of Linus' tree each
> day.
>
>> For example for next-20110928 I see in Next/quilt-import.log:
>
> For the quilt series, the owner of the series puts a BASE or NEXT_BASE
> comment in the series to tell me what their series is based on.  I import
> each quilt series staring from that base into a branch and then merge
> that branch.
>
> For the git trees, I just fetch and merge them.

Thanks for all the details!

Last question, do you do merge conflicts manually? I was also trying
to see if I can simulate a linux-next merge myself to see what you do
but I didn't see the scripts you use, any pointers would be
appreciated.

  Luis
