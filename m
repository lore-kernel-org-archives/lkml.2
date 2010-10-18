Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0JRMkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:40:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47728 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0JRMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=d3yHKCaBSVXM5nzZcJQNwFNRPjQJOG11+54lsEOarXX3TQRCQI8vblWg+Sj8lfZrJG
         NnbZhU0RMobgjtxEWEtl3ZyTY0TrlPrgVvqg0AksDqqIvYAlHPTrY1VeObj1HVViUMeB
         5GBYWJe3xw+tJ6WrbA9e0hAPPSVUM6al7B1zM=
MIME-Version: 1.0
In-Reply-To: <20101018092415.3AD1.A69D9226@jp.fujitsu.com>
References: <1287235165-27841-1-git-send-email-andrea.gelmini@gelma.net>
	<1287235165-27841-11-git-send-email-andrea.gelmini@gelma.net>
	<20101018092415.3AD1.A69D9226@jp.fujitsu.com>
Date: Mon, 18 Oct 2010 14:40:06 +0200
X-Google-Sender-Auth: nvKypOLvRdbPzPuQ5anTB_92at0
Message-ID: <AANLkTim0H82Wp7Ld_6nvW-XYdpbjBqJBgH69GzeJzGe2@mail.gmail.com>
Subject: Re: [PATCH 11/16] mm: fixed typos
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:

Hi Motohiro,
    and thanks a lot for your answer.

> Please cc lkml and linux-mm when you post any patch. (I've added them)
> but anyway, this looks good.

   Some people are bothered by trivial patches in mailing list.
   So I try to contact direct maintainer in first place. After few
months, if I have no
   signs, I re-send to mailing list.
   Anyway, now I send this one in lkml.

Thanks a lot,
Andrea
