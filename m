Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1CGRnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:43:17 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46379 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1CGRnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=i959i9BaW1bxdqy2rLx2ev0KcDW2ijJMk3HgvfaKLG54NUv2dWJyfw0s09x7YT9BgR
         JgJYi31Ewp4RsOioTQb3G4A8yeZCk3pZh2rTS6C9kgibsASo1M9nLdPHJhCUDFWVQVVa
         rhVghQV+CX4xMvshDQaR//CVUkBMOPyXiUCLE=
MIME-Version: 1.0
In-Reply-To: <GTlFTeOGjrB.A.DoE.Sq3cNB@chimera>
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera> <GTlFTeOGjrB.A.DoE.Sq3cNB@chimera>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 7 Mar 2011 18:41:47 +0100
X-Google-Sender-Auth: LcdUMMzXT_lfRr8cuLwjGGQXgSo
Message-ID: <AANLkTimPYKP8S24ivRZXePhc5wM6n3ivzdpJSBaCvG6a@mail.gmail.com>
Subject: Re: [Bug #29312] Unmounting fails even after the underlying device is
 long gone
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 1:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=29312
> Subject         : Unmounting fails even after the underlying device is long gone
> Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> Date            : 2011-02-17 19:20 (18 days old)

Unmounting works fine again with 2.6.38-rc7+, but I see now a huge
number of error messages in the system log:
# grep -c '^Mar  7 18:37:4.* kernel: sd 6:0:0:0: rejecting I/O to
offline device$' /var/log/messages
4987

Bart.
