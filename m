Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0FHIdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:33:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0FHIdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:33:06 -0400
MIME-Version: 1.0
X-Originating-IP: [134.134.137.73]
In-Reply-To: <Pine.LNX.4.63.1006081302110.12495@eng1.gmrt.ncra.tifr.res.in>
References: <Pine.LNX.4.63.1006081302110.12495@eng1.gmrt.ncra.tifr.res.in>
Date: Tue, 8 Jun 2010 16:33:03 +0800
Message-ID: <AANLkTikAAzrsSnQwtUqU-SpVwgdwfdgUWdEjtFiY1wbC@mail.gmail.com>
Subject: Re: requires info abt scheduling algo
From: Lin Ming <lin@ming.vg>
To: Raju Rameshwar Uprade <rajsingh@gmrt.ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 3:33 PM, Raju Rameshwar Uprade
<rajsingh@gmrt.ncra.tifr.res.in> wrote:
> Hi,
>      can anyone tell me..which scheduling algo is used in current linux
> kernel and how it works...

CFS (Completely Fair Scheduler),

Some info under linux-2.6/Documentation/scheduler

Lin Ming

>
>
>
> Thanks,
>  Raj singh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
