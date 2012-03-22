Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2CVVrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:47:12 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:29006 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752827Ab2CVVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:47:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zammdxkVM1mWnOZJh28Xfc3yAEeBBONrs13lFT.ZSQ1l5tu
 UjobQ3mMuiSBfrJYcXWqARYb3utV7EU8wJyZW55Crn0qoo5WQ7sjpXmhxzlV
 Hqeuydxs20l2G8Ju6gs_sYLXir4vgsKxn0u7urvg9oFmvQ.YpV7aZ8oMA38U
 M1xkE89am1X0iyu3SkuwYzlwGxDDC.79_nkYsFR_lvjKQekCb6DtNPJZDXK0
 WDjGVwnVbobdgAd9fiQQ6jURKaEiNy8Qa63NF19nGH6n1mcgzJj1lW6BCkyi
 CPaAxFBIalx7HJGDtkfIw5O7BXnHvDbDmIDPYSsg5xFZd3B9mIaC9RLJLXIR
 0UQkzkEQ28N_Xxcy2vrLFQsO_BoZ.4jQ5dMKdIXwf7jHwBlVcW0iv3nUQjDn
 iRQuHlUEazZLJxf0Gv5v.zESy9balPdnNoOBic1pK
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 16:47:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Borislav Petkov <bp@amd64.org>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] tools: Add a toplevel Makefile
In-Reply-To: <20120322210431.GA1462@aftab>
Message-ID: <alpine.DEB.2.00.1203221646450.32581@router.home>
References: <1332435713-32143-1-git-send-email-bp@amd64.org> <1332435713-32143-3-git-send-email-bp@amd64.org> <alpine.DEB.2.00.1203221332390.25011@router.home> <20120322210431.GA1462@aftab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Borislav Petkov wrote:

> It basically does:
>
> $ make -C slub/ clean
>
> which runs the target of the same name in the Makefile in slub/.

Ok.

Acked-by: Christoph Lameter <cl@linux.com>
