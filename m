Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0KWG7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 01:59:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0KWG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 01:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OiRO10MpeXx1hyZd0zdJwDITO5Eyxb476BYHqTDj7FiqBO4+3qXLP0BqsqYbrZwnsh
         uxwpNMuE79VNzmZxKswKPIYBUUIUtx6zZeNJ9TkAhXXKWqqM8dSz7JRTxv+svn2WT3F1
         P6Vmf65qCx7RZ6FvpAH5SMVxbMNl82rSptssc=
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <20101123051259.GF1522@bicker>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
	 <20101112120834.33062900.akpm@linux-foundation.org>
	 <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
	 <20101114092533.GB5323@albatros>
	 <20101114180643.593d19ac.akpm@linux-foundation.org>
	 <1289848341.2607.125.camel@edumazet-laptop> <4CE268C8.5010203@panasas.com>
	 <20101122155043.fbbb74f4.akpm@linux-foundation.org>
	 <1290471649.2704.24.camel@edumazet-laptop>
	 <20101122163234.5470e33e.akpm@linux-foundation.org>
	 <20101123051259.GF1522@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 07:59:29 +0100
Message-ID: <1290495569.2704.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 08:12 +0300, Dan Carpenter a écrit :

> Well, that sucks...  I know I wrote some code that relied on holes
> getting zeroed as well.  Is there no option to GCC to make this work?
> 

Apparently not.

At least, commits 0f04cfd098fb81fded74e78ea1a1b86cc6c6c31e and
1c40be12f7d8ca1d387510d39787b12e512a7ce8 were safe, as structures that
were touched dont have holes.



