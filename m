Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab0JFBPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:15:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49133 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593Ab0JFBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wP4CX1+jMBC6ejoL+N9I9ZFIyIsrfvwNgVOjz13mx0KKW07pYlOOp5Yvz74JL5CyVJ
         l4va4XPhKUhp94yJ2t7A3Nvz1of6rkicXXAk6h/n0WI+6k4PYgTNCgz0s96HoFSEaiVn
         KYh/r88NlZgR/5pBrPKYyXowh1wybMaIgFVu8=
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 21:15:16 -0400
Message-ID: <AANLkTi=GrHjrZaKdX8DiDf2nT-SByifSxn2sW_0NQWd_@mail.gmail.com>
Subject: [PATCH 00/28] Staging: comedi: Fixed numerous file so that it had
 little or no complaints from checkpatch.pl
From: T Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed a lot of coding style errors, that checkpatch.pl had found. I
didn't do some files in the drivers/ subdirectory because the warnings
that were being produce was spacing errors. So spacing wasn't that
serious ,so I skim and look for if it was anymore wranings or errors.
There was none so I skip the rest.

This is my last full scale checkpatch.pl patch series, as I'm going to
try to contribute more interesting things to the Linux kernel. :)

Thanks,

Tracey D
