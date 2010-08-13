Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab0HMONl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:13:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46051 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab0HMONi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=r+8FXg4U26tcImXCt2A1rNpZemjiJEKhLnTWWpF/ToRfWivWT0SHjiY2RupVycnp7L
         XZmSbSlf9xO2ESCSO7s22LyHpsA4i/knJYC1lrm7NbNZCNsTsK6ZOg1OqztZPmvl84Au
         WUG54eTKmzopu+gz8L0FzFy7gvkymJJvJQw1s=
MIME-Version: 1.0
In-Reply-To: <20100813140810.GB24029@mother.pipebreaker.pl>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com> <20100813131422.GA615@centrinvest.ru>
 <20100813140810.GB24029@mother.pipebreaker.pl>
From: Ben Chociej <bchociej@gmail.com>
Date: Fri, 13 Aug 2010 09:12:41 -0500
Message-ID: <AANLkTikA_S5+vv=EM8hiakG0mYfanuOpRsicpr3_TZgQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        bchociej@gmail.com, chris.mason@oracle.com,
        linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
        mrlupfer@us.ibm.com, crscott@us.ibm.com, mlupfer@gmail.com,
        conscott@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 9:08 AM, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> On Fri, Aug 13, 2010 at 05:14:22PM +0400, Andrey Panin wrote:
>> On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
>> > From: Ben Chociej <bchociej@gmail.com>
>> >
>> > Modified mkfs.btrfs to add hot data relocation option (-h) which
>> > preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
>> > BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
>> > relocation code.  Also added a userspace function to detect whether a
>> > block device is an SSD by reading the sysfs block queue rotational flag.
>>
>> IMHO this policy is too inflexible. What if I have large array of slow SATA
>> disks and some fast SAS ones ?
>
>  I'm hoping that this is just first cut, and future versions will have options.
> For now, it is totally unusable without a way of using mirrored SSD for
> hot data.
>  Ideally, hot storage devices should be online selectable and changeable.
>
> --
> Tomasz Torcz                                                       72->|   80->|
> xmpp: zdzichubg@chrome.pl                                          72->|   80->|
>
>

This is very much just a first cut. Our goal here was to get a lot of
the legwork and experimental coding out of the way to enable to Btrfs
to *fully* tackle heterogeneous storage in the future.

BC
