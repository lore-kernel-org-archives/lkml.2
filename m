Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab1ERMY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:24:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34128 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab1ERMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=Q4oSIMeT7EF54RTS3Q+RyXbmozPHA8K5DwlGVkNUY31G12u27te28zbg/62NjQtKEO
         nnIMZ1PChKlmjR/QxwkD/4e0rJksqKs4z4FqFk/rRp6kFKNNh6YbwZcS5W/E2iWJotm+
         FQMWGHhEYJgGg9FQNi9CxXOJhl9TJxN5ZwKo0=
MIME-Version: 1.0
In-Reply-To: <BANLkTin1uWZUS21Ey6chY0E=Nu50MJFCWA@mail.gmail.com>
References: <BANLkTin1uWZUS21Ey6chY0E=Nu50MJFCWA@mail.gmail.com>
Date: Wed, 18 May 2011 14:24:26 +0200
X-Google-Sender-Auth: er8-XGBiCfpnzgDgYgeKmjtG29A
Message-ID: <BANLkTinXnjvG4p9WqoYc7ttyXZ7gQSBhsQ@mail.gmail.com>
Subject: Fwd: Six month old regression with dataloss, confirmed but no clue
From: roucaries bastien <roucaries.bastien+linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I resend an email about https://bugzilla.kernel.org/show_bug.cgi?id=29162

This bug was confirmed by Frederic Weisbecker but we have no clue how
to reproduce quickly. Only run kamil and git for some time and get
stuck.

We are even not sure if it is a reiserfs bug and a core fs bug. It
seems related to acl is the only clue.

Any help is welcome.

Thansk to frederick for trying to reproduce so far

Bastien

Ps: sorry for resending typo on lkml
