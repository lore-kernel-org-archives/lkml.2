Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0HDH5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:57:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60853 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0HDH5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:57:01 -0400
Date: Wed, 04 Aug 2010 09:55:16 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 1/3 v2] media: Add a cached version of the contiguous video
 buffers
In-reply-to: <1280848711.19898.161.camel@debian>
To: "=?utf-8?Q?'Richard_R=C3=B6jfors'?=" <richard.rojfors@pelagicore.com>,
        "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Douglas Schilling Landgraf'" <dougsland@gmail.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>
Message-id: <000d01cb33aa$606faee0$214f0ca0$%osciak@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: AcszIC71j/uiyNpETM2zQ9w+F1Xp7QAh7sFQ
References: <1280848711.19898.161.camel@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

>Richard Röjfors wrote:
>This patch adds another init functions in the videobuf-dma-contig
>which is named _cached in the end. It creates a buffer factory
>which allocates buffers using kmalloc and the buffers are cached.
>

Before I review this in more detail, could you elaborate more on
this? How large are your buffers, can kmalloc really allocate them
for you? I am not convinced how this is supposed to work reliably,
especially in a long-running systems.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





