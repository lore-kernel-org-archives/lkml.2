Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0LTMMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:12:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36403 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0LTMMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:12:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lHnlOZKCQjWjyw6qqpv8Gv0oXveBOp/kMUVPHQDP0bGRMKXy3KlUYnc0aig8MpZb55
         WnNFUWadW04OEpr+CRkrFMvjrBclRaRg0VevU1UO8014+3G+aJ+ognPf/1VuunpTN3xz
         txJU2xkymisQtrsv1UXNrjUKwk05QhJ5D542I=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101220230007.e82487b8.sfr@canb.auug.org.au>
References: <AANLkTi=gjHyMt=W4-+PSMzt7PN7i-_Yvmx7EE8z0z74q@mail.gmail.com>
	<20101220230007.e82487b8.sfr@canb.auug.org.au>
Date: Mon, 20 Dec 2010 13:12:06 +0100
Message-ID: <AANLkTin4dvM1B8GkxZH6DADJVg4ZWNSQvUHAviy-4O2J@mail.gmail.com>
Subject: Re: linux-next: Tree for December 20
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ftpadmin@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 1:00 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi,
>
> On Mon, 20 Dec 2010 12:46:08 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> >
>> > [The mirroring on kernel.org is running slowly]
>>
>> Indeed, you know what's wrong with the mirrors?
>
> I don't know what is wrong.  The mirroring just seems to be much slower
> in the last week or so.  Today, it was just over three hours from when I
> uploaded linux-next until it was mirrored out.
>
> I have cc'd the admins.
>

Thanks.

>> Can you upload the diff-patch (patch-v2.6.37-rc6-next-20101220) to [1]
>> from your local-tree or place it somewhere else?
>
> I cannot upload directly to www.kernel.org, I up load to the same place
> on master.kernel.org and the mirroring system puts it on www.kernel.org.
>

I could download the diff-patch.

$ wget http://www.kernel.org/pub/linux/kernel/v2.6/next/patch-v2.6.37-rc6-next-20101220.bz2

- Sedat -
