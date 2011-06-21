Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab1FUQB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:01:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1FUQB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=LtNXC6ORhUslo8EH9ZbduGg7ham5koFBuFAN9Xs9stnjSvSSdElZMd7U3MlJYETx9j
         GTIcUQo6xwjqLd6XMjmxRmcBpjR21cQR1dRw3w8ICx/V/RExECsbGuyMPwXxUWtFF5Ep
         JZ4hlr8HusQLBIN4pf2zS2sqxJN2Gkwu7EEmY=
MIME-Version: 1.0
In-Reply-To: <a8361d4ade24beeb5dbe34340b2f98ff97c6afe2.1308671562.git.joe@perches.com>
References: <a8361d4ade24beeb5dbe34340b2f98ff97c6afe2.1308671562.git.joe@perches.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 21 Jun 2011 12:01:36 -0400
X-Google-Sender-Auth: o8COUlpySLXlQMSuE34tEjL9XDY
Message-ID: <BANLkTi=uLXZ9X84Tsmm6MTP=hh5NH6ze4A@mail.gmail.com>
Subject: Re: [PATCH] checkpatch.pl: Add ability to ignore various messages
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:57, Joe Perches wrote:
> Some users would like the ability to not emit some of the
> messages that checkpatch produces.

before people start complaining that this allows people submitting
patches to lkml to easily ignore stuff, the point of this is to make
it easier to use checkpatch in other projects and integrate into scm
hook scripts

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
