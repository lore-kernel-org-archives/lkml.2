Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0D0LbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:31:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56789 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0D0LbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TUi7cMDdpuxs1OiphVwDTUClKParkU9Kyqo7V4LwTPizkHCc9tx+MB7i7q7DRSnhF5
         EZi9vqKGkXlHEFBc3JeOMNQ/7Bb/8zoRUrgppSe9f9LJcCesw545F8kzQ6qHEZeUdHYM
         605evN9qrrgowX9tWFJmWfcG5WM5ISscBFT3Y=
MIME-Version: 1.0
In-Reply-To: <20100427111759.GA13859@logfs.org>
References: <20100422203358.GB30749@logfs.org>
	 <20100423205518.GB7008@logfs.org> <20100426094810.GE27497@kernel.dk>
	 <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk>
	 <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org>
	 <20100426163126.GD4364@logfs.org>
	 <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com>
	 <20100427111759.GA13859@logfs.org>
Date: Tue, 27 Apr 2010 13:31:11 +0200
Message-ID: <h2h4aa525de1004270431hd98c271ag61462bdb778f7769@mail.gmail.com>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
From: Paolo Minazzi <paolo.minazzi@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you add "rootfstype=romfs" to the command line, does the problem
> still exist?
>
> Jörn

Jorn , you are right.
It seems work....
please wait....
