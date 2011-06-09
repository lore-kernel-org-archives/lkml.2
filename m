Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1FIDSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:18:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54682 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab1FIDSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Psavix7N+B+5XLPj1Qd/ov9YDfjYbetxS/w86iNkwBvNHqEa4lPY5P6RclsXqjEdUC
         /qyIfOzXNEG+9/WFHqCSLhop0usm86S2j1yqr5KWkACECLXYRn7QYdX1Pwh5ZU43696S
         28LfQGrrvmUg2BxiVNyL3fa6dEeZgqtVJzT1k=
MIME-Version: 1.0
In-Reply-To: <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
	<BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
Date: Thu, 9 Jun 2011 06:18:10 +0300
X-Google-Sender-Auth: 4V-ZQQ6zHTGBGcgzgzNHF66bkTU
Message-ID: <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
From: "Amir G." <amir73il@users.sourceforge.net>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>> But I do understand the difference. And also, when it comes to fs level
>> snapshotting I would suspect that it would do something we can not do
>> with the current solutions, for example per-file or per-directory snapshots,
>> cat ext4 snapshots do that ?
> Hi Lukas,
>
> I noticed that there is no answer to this question in the thread.  I

I think I answered this question with No it can't ;-)

> can give the question the answer that ext4 can snapshot per-file or
> per-directory, and can exclude some files or directories from being
> snapshotted.
>

So the full answer is that ext4 snapshot CAN exclude
certain files/dirs from snapshot, but this feature is not fully implemented yet
(I have it in a dev branch)

> --
> Best Wishes
> Yongqiang Yang
>
