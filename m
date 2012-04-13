Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab2DMNwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:52:10 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:33914 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755303Ab2DMNwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:52:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: w6cH5IQVM1kSpAfnr.P7fXB_CyWPlz8caifBveWRlze32kR
 DvmFaMGzzSSUvGt7xTzu82LIBZn2kWXbGbJroxINmAu805wTpI73TW_SAOUi
 b2rqRj6CUvJICaDTX5vJuYfBr8RiJpQlbFEKBRQhzx0KCRGXcr_VTPLswaZw
 ttd0TvDTtXbfMh8t8NH717vZhD7yK28001LbKrJJ6TyF8lftKKNmWVRlwM5J
 E8bCXGgepntXMUUAAh1Cc3beam9nKn1pGwtZ_mQ7QigIsNUp0e.5brGPDaHv
 tRHeNHrrn62fgtYGpgi5XCNeG6QSBH_F9IgqctoyXu2TKamC1WtEjVpNv801
 SwcdQFzGSk1KHm6iZAs6POWyhugIOAIc6MTCmpXeajQYQjwsZaf3Xuq_NaS8
 il8_wm9kGwhucwpqcsdyoL.iiXIX8NUcRANM-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 13 Apr 2012 08:52:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sasha Levin <levinsasha928@gmail.com>
cc: akpm@linux-foundation.org, hughd@google.com, dave@linux.vnet.ibm.com,
        ebiederm@xmission.com, davej@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: fix NULL ptr dereference in move_pages
In-Reply-To: <1334321902-7143-2-git-send-email-levinsasha928@gmail.com>
Message-ID: <alpine.DEB.2.00.1204130851470.10789@router.home>
References: <1334321902-7143-1-git-send-email-levinsasha928@gmail.com> <1334321902-7143-2-git-send-email-levinsasha928@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Sasha Levin wrote:

> Commit 3268c63 ("mm: fix move/migrate_pages() race on task struct") has added
> an odd construct where 'mm' is checked for being NULL, and if it is, it would
> get dereferenced anyways by mput()ing it.

Acked-by: Christoph Lameter <cl@linux.com>

