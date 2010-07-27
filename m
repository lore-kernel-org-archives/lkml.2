Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0G0XSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:18:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33135 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0G0XSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cqb4wBJfYfm1nyLpLThhZfPeWyKgXsCHvLJpkCGSo7U4U4K/aVoML1/6kLbtyym3/R
         tUIfgL86lfmnv8TJfsVMo1/We6DPUtPNtO98j87nwfVJ1GiPrLIUrfSNngJb/52GQlq5
         ABJ/KfMwrGoCSwzl5TyWXto/PCYxt6qGRjmtU=
MIME-Version: 1.0
In-Reply-To: <201007280110.46059.diegocg@gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com> 
	<201007280110.46059.diegocg@gmail.com>
From: Ben Chociej <bchociej@gmail.com>
Date: Tue, 27 Jul 2010 18:18:23 -0500
Message-ID: <AANLkTi=x9q1XOu_6F2hOv_ZPoM+McKz9Nv2Q5GZNfa4a@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
To: diegocg@gmail.com
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
        mrlupfer@us.ibm.com, crscott@us.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 6:10 PM, Diego Calleja <diegocg@gmail.com> wrote:
> On Miércoles, 28 de Julio de 2010 00:00:18 bchociej@gmail.com escribió:
>> With Btrfs's COW approach, an external cache (where data is moved to
>> SSD, rather than just cached there) makes a lot of sense. Though these
>
> As I understand it, what your proyect intends to do is to move "hot"
> data to a SSD which would be part of a Btrfs pool, and not do any
> kind of SSD caching, as bcache (http://lwn.net/Articles/394672/) does?
>

Yes, that's correct. It's likely not going to be a cache in the
traditional sense, since the entire capacity of both HDD and SSD would
be available.

BC
