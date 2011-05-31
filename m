Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1EaXwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 19:52:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41962 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab1EaXwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 19:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=La1IXzZeObE1FPsv8x2vt2ZBtqclDjwzjS4Ldp6lB9WKyL3bB7eeWrYxaTEcxk6Iqs
         nvdPM446ThNb2MiTltM3oUCNio5wwREAsZeGGbgCDIDKGjITZY5+mAYXCSyBAsBiqdc+
         odpJQZSH6i8okjdK3jdKsb+3kSKAAGK/wxqYg=
MIME-Version: 1.0
In-Reply-To: <20110531230702.GE31742@noexit.corp.google.com>
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
	<20110531225713.GA10985@wotan.suse.de>
	<20110531230702.GE31742@noexit.corp.google.com>
Date: Wed, 1 Jun 2011 08:52:21 +0900
Message-ID: <BANLkTi=kFh-km1NHSNczsNGi-5Xt844dmw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: use proper little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Mark Fasheh <mfasheh@suse.com>, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        No argument here.  Akinobu, do you want me to send it with ocfs2
> fixes, or are you going to push it along?
>
> Acked-by: Joel Becker <jlbec@evilplan.org>

Thanks. Please add it to ocfs2 tree.
