Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab1FWNmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:42:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41685 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1FWNmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=u/jZ3g6XvkvR2sEjzeb/Srq7indY9iGjyhGWRyVPeSphLOVfvQJ+7BDavrwSgEpeVv
         0HF0tJFeiiZ7mFYeq0VGuc4OttLjxAHxtU8/zpuY2qI3DGw5MSyVLmaTe05j5ezZ61Mq
         KNVmNHLOmfaO/HqirLyVF4oB0xu8kXCA8Ifko=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=CPEmFVbwuSBSsQjv4ZqHX+Ng8gw@mail.gmail.com>
References: <20110618213803.521db1b3@debxo>
	<20110618214203.0028ba85@debxo>
	<BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
	<1308631634.31157.7.camel@dcbw.foobar.com>
	<20110621001805.1caecc82@queued.net>
	<BANLkTi=CPEmFVbwuSBSsQjv4ZqHX+Ng8gw@mail.gmail.com>
Date: Thu, 23 Jun 2011 14:42:17 +0100
X-Google-Sender-Auth: 9MQk9ilRV266j2frUQRfqhS6R_8
Message-ID: <BANLkTin00W9f40PUjbjgYVRydU7ttJFr9A@mail.gmail.com>
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Dan Williams <dcbw@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        cjb@laptop.org, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 June 2011 09:05, Daniel Drake <dsd@laptop.org> wrote:
> The other changes look fine, and we will figure out sd8686 and send a
> later pull request for that. Dan, can you send over
> SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64, and any release
> notes/changelog you may have? I wasn't aware of this release.

Also, could you take a look and see if there is some kind of archived
changelog or release history that would link the 3 firmware versions
in question to the same release stream? If it seems obvious that one
follows on from the other it would avoid me having to pester Marvell
about this.

The 3 versions in question are:

1. The version in linux-firmware
$Id: sd8686-B0, RF868X, FP4, 9.70.3.p36 $
RC: , yhou, 2008/09/08, 19:11:06
md5sum: 20208583d441d1ecd7a05d5e5cda5856

2. The OLPC version, shipped in Fedora:
$Id: sd8686-B0, RF868X, FP4, 9.70.7.p0 $
RC: , yhou, 2008/11/11, 13:10:01
md5sum: b4f8be61e19780a14836f146c538c5dd

3. The latest version that you've found
SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64

Thanks,
Daniel
