Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1HBT7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:59:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1HBT64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:58:56 -0400
MIME-Version: 1.0
Date: Tue, 2 Aug 2011 23:58:55 +0400
Message-ID: <CABAWUvXNYBCrwPzMBKSum-HkEBFphCg0NdNM0cFYVWW34EN4tw@mail.gmail.com>
Subject: caching of page frames
From: Frank Coldwell <spaceportz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is what I have read in book about Linux kernel:

"Linux clears the PCD and PWT flags of all Page Directory and Page
Table entries; as a result, caching is enabled for all page frames,
and the write-back strategy is always adopted for writing".

Are there situations where better performance can be achieved by
disabling caching of page frames, because overhead is just setting one
flag, and maybe there are situations when we can be sure
that caching of page frame is not needed ?

Kind regards,

-- 
marc coldwell

software engineer
