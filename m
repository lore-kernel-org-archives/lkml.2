Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0GIJWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:22:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54443 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0GIJW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CfbGQHWxET2644EwL8id1NOHBiC4VYuiW52qrFBqZmPQ7aGBams02aGVTzRFIyYCws
         HiOFasho5fiJrmdsFkSZmdT9tsJv9jCSELHO2LvaG2VjRbpb4DPGT8gNUFLupXlYBroq
         nWl1R+5Zx2tPBjmhpWnOHA9FBgfz2UpCYidHM=
MIME-Version: 1.0
In-Reply-To: <TXb9XdQzJoD.A.f6H.kLmNMB@chimera>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.f6H.kLmNMB@chimera>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Fri, 9 Jul 2010 11:50:42 +0300
Message-ID: <AANLkTikKPkL7N2nD1Z-vsUU2pRkfk52KSgTPkFckpNFx@mail.gmail.com>
Subject: Re: [Bug #16353] 2.6.35 regression
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 02:41, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16353
> Subject         : 2.6.35 regression
> Submitter       : Zeev Tarantov <zeev.tarantov@gmail.com>
> Date            : 2010-07-05 13:04 (4 days old)
> Message-ID      : <loom.20100705T144459-919@post.gmane.org>
> References      : http://marc.info/?l=linux-kernel&m=127836002702522&w=2


There's a working patch by Steven Rostedt at
http://marc.info/?l=linux-kernel&m=127864600425732&w=2

-Zeev
