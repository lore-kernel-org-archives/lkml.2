Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0H3FNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:13:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab0H3FNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hYEfXT6M4HTTbnLiIGsckqwo1vSJswDJQKKvv2iUb/+OVc3wKag5dxJsZ1I32B+j7P
         lxWHPYjq2s5kd+jpvrvFBZCb+DQh19U2lhkbWH12jqv5NPBQoz6h5WBQICJBraYM4IJt
         WVg1vH0IqV/S6l+Zcl4dw4IFa/nqgvHre0am0=
MIME-Version: 1.0
In-Reply-To: <ByD_7B96czP.A.XbB.bcueMB@chimera>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.XbB.bcueMB@chimera>
Date: Mon, 30 Aug 2010 09:13:04 +0400
Message-ID: <AANLkTinruBeRL6im9qG3Y6jqKiYujzpLoAA-v1qDz34S@mail.gmail.com>
Subject: Re: [Bug #16613] i8042 kernel module failed to load after unloading
From: Victor Seryodkin <vvscore@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verifying: the bug is still actual

On Mon, Aug 30, 2010 at 3:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16613
> Subject         : i8042 kernel module failed to load after unloading
> Submitter       : Seryodkin Victor <vvscore@gmail.com>
> Date            : 2010-08-17 17:01 (13 days old)
>
>
>
