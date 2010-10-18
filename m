Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0JRRNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:13:10 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:20989 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757445Ab0JRRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:13:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: wpqy52oVM1nATBOsKxpPFJrGtyuNWCKS.9Rdu0BvXDUp70O
 hdnw-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 18 Oct 2010 11:12:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
In-Reply-To: <1287416380.2409.13.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010181111500.2092@router.home>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>  <1285762729-17928-17-git-send-email-david@fromorbit.com>  <20100929215322.ff635d3e.akpm@linux-foundation.org>  <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd> 
 <1287217748.2799.68.camel@edumazet-laptop>  <20101016020744.366bd9c6.akpm@linux-foundation.org>  <1287221475.2799.123.camel@edumazet-laptop>  <1287238754.2799.376.camel@edumazet-laptop>  <alpine.DEB.2.00.1010181015290.755@router.home>
 <1287416380.2409.13.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Eric Dumazet wrote:

> Nope, on UP, we dont use a per_cpu field, just a "s64 count".
>
> struct percpu_counter {
>         s64 count;
> };

Ok that is percpu counter specific then.

