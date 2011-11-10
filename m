Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036Ab1KJPJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:09:03 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22373 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933842Ab1KJPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:09:01 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Io2amzQVM1lX2fA9H6fed_qvzkK.cTYtQ42AXIXnUsVzZpM
 GdovRij45E3xG.v3ivoUgheN8K2ewqVGFpM8bk0dwTAoNK8Edok3fpL9rYt4
 SSmGs9W6EvT4scpYgkaJuHqaghj_MCnq1DdAg30eJODkJ3sSNalhE1u8ZglV
 DyiqHHt9KLCeJHfl9sJsEHFHtCqs84xNbMqB2wcDX3JVdeoYfGPsU1ydjMjE
 fRoKyqkkEcqsMZk3u2kMKtPkiQHecRvTOK6A_GrHsSkS7WdMlh84Qg4sIF0c
 _EnqXnzo3Nwy5uspNZOQeYSJ0y62M2foHWtS0I96mSA3zppVviE4A0ccAcGA
 .VVYrdCAo_C3etjpL_7LvQpKwaHBUdomrgByYBj1b_4AAit_Z8QgB1k6cPEA
 SHTtpQGkWuHZi9GB1c6tk
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 Nov 2011 09:02:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm,x86,um: move CMPXCHG_DOUBLE config option
In-Reply-To: <1320933860-15588-4-git-send-email-heiko.carstens@de.ibm.com>
Message-ID: <alpine.DEB.2.00.1111100901590.19196@router.home>
References: <1320933860-15588-1-git-send-email-heiko.carstens@de.ibm.com> <1320933860-15588-4-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Heiko Carstens wrote:

> Move CMPXCHG_DOUBLE and rename it to HAVE_CMPXCHG_DOUBLE so architectures can
> simply select the option if it is supported.

Acked-by: Christoph Lameter <cl@linux.com>
