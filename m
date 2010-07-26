Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0GZLdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 07:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab0GZLdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 07:33:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1280132829-8224-1-git-send-email-segooon@gmail.com>
References: <1280132829-8224-1-git-send-email-segooon@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: dhowells@redhat.com, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] afs: do not set task state after schedule_timeout()
Date: Mon, 26 Jul 2010 12:32:56 +0100
Message-ID: <5712.1280143976@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kulikov Vasiliy <segooon@gmail.com> wrote:

> schedule_timeout() sets tast state to TASK_RUNNING, so there's no need
> to set it explicitly.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
