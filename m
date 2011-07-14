Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1GNHaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 03:30:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42715 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1GNHaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 03:30:09 -0400
MIME-Version: 1.0
In-Reply-To: <87k4blyga3.fsf@elisp.net>
References: <1310529537.96670.YahooMailClassic@web29502.mail.ird.yahoo.com>
	<87k4blyga3.fsf@elisp.net>
Date: Thu, 14 Jul 2011 10:30:08 +0300
X-Google-Sender-Auth: GuHNKhHj2o13MZJWM9xo-PwGHqQ
Message-ID: <CAOJsxLHtzxmszT-5LdqQ_SHCHN=2b+sCRaBBWhR=FZgvEsMVRA@mail.gmail.com>
Subject: Re: [PATCH] hfsplus: Add record offset check
From: Pekka Enberg <penberg@kernel.org>
To: Naohiro Aota <naota@elisp.net>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 1:20 AM, Naohiro Aota <naota@elisp.net> wrote:
> Hin-Tak Leung <hintak_leung@yahoo.co.uk> writes:
> Purpose of this patch is as same as commit
> 9250f925972d03ccc0c0a4dd4e9b794d2ef6d52b. This is a patch to handle
> on-disk corruption without oopsing.

FWIW,

Acked-by: Pekka Enberg <penberg@kernel.org>
