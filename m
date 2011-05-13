Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab1EMRjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:39:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33906 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1EMRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=re7COuzMjGxTPC5625mULTDPxPp8FC2UTRS25uDciYJ99CQFw2hMh/NwtYx/zTfV3/
         ScP+1FNvrOfEKeAyJDh2D2Hf3BAWGf3yPSfM/kcxioyQpJY9fpu5PKbxicOXbNrn0apt
         R4VDQQLG1uBiNqDe0RN7pJZ0HnY8ThYLU+S0U=
MIME-Version: 1.0
In-Reply-To: <201105131856.44250.rjw@sisk.pl>
References: <201105120025.34531.rjw@sisk.pl>
	<20110513143758.33f68a77@xenia.leun.net>
	<201105131856.44250.rjw@sisk.pl>
Date: Fri, 13 May 2011 19:39:51 +0200
X-Google-Sender-Auth: c0NpOahFr6JrrRKZQeFqsuEtigU
Message-ID: <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com>
Subject: Re: AHCI driver problem on ICH (Re: AHCI driver problem on
 SB700/SB800 w/ Acer Ferrari One)
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can you guys please take a look at bug#34692?  It seems to be the same problem.

  https://bugzilla.kernel.org/show_bug.cgi?id=34692

The offending commit seems to be 270dac35c2.  Does reverting it
resolves the problem for you guys too?

Thanks.

--
tejun
