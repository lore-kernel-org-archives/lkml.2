Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab0LSTYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 14:24:31 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61961 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab0LSTY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 14:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C+wPCCWWQ1trBqGxXeKKUXXcjEfJ8qAVZuvOD3O/wimBerVUHzSxb7EisKS/Yqw2ae
         yVAm2WBqVWy1DGxWF0p19uq0njNMPhBIwqMKfHxzwExIxTI1W1HqA0pin/C8dWE/0uCc
         FBhu1WciV+2S+Qi7BfvHxtbt7WPVpgWBF0wd8=
MIME-Version: 1.0
In-Reply-To: <6Ue85L6pKCJ.A.9eD.8dfDNB@chimera>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
	<6Ue85L6pKCJ.A.9eD.8dfDNB@chimera>
Date: Sun, 19 Dec 2010 20:24:28 +0100
Message-ID: <AANLkTinRtWhM=NdjYWYNN5XBtxdUtCGVyPA_YhLC2BSm@mail.gmail.com>
Subject: Re: [Bug #24772] Crash with btrfs rootfs on dm-crypt [ kernel BUG at
 fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
As I wrote in the report, the bug destroyed my installation, so I
don't have linux anymore on that laptop.

On Sun, Dec 19, 2010 at 1:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=24772
> Subject         : Crash with btrfs rootfs on dm-crypt [ kernel BUG at fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2010-12-10 20:30 (10 days old)
> Message-ID      : <AANLkTi=j9zsaYNcu=NgGV=HfE-3rNHzVswov8VrgwjQp@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=129201308706568&w=2
>
>
>
