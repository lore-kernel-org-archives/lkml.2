Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2H2DEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 23:04:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2H2DEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 23:04:04 -0400
Date: Tue, 28 Aug 2012 20:04:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Davidlohr Bueso <dave@gnu.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] oom: remove deprecated oom_adj
In-Reply-To: <1345819351.2574.6.camel@offbook>
Message-ID: <alpine.DEB.2.00.1208282003490.24229@chino.kir.corp.google.com>
References: <1345819351.2574.6.camel@offbook>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Davidlohr Bueso wrote:

> The deprecated /proc/<pid>/oom_adj is scheduled for removal this month.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Acked-by: David Rientjes <rientjes@google.com>
