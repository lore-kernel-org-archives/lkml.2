Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2E1Sei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:34:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50562 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab2E1Seg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <1338195855-14462-1-git-send-email-eric.miao@canonical.com>
References: <1338195855-14462-1-git-send-email-eric.miao@canonical.com>
From: Eric Miao <eric.miao@canonical.com>
Date: Tue, 29 May 2012 02:34:15 +0800
X-Google-Sender-Auth: YlWosWHaEw2iyQ3waCeWk1mBjs4
Message-ID: <CAMPhdO_qwDmoLUpHZpNTJLLPhzyxdkKD0sh2Pu21p6uPw-_HYg@mail.gmail.com>
Subject: Re: [PATCH] fbdev: make FIRMWARE_EDID depends on X86
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Eric Miao <eric.miao@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 5:04 PM, Eric Miao <eric.miao@canonical.com> wrote:
> The only place where CONFIG_FIRMWARE_EDID is used is in fbmon.c,
> and only when CONFIG_X86 is defined, this implied dependency will
> be better specified in Kconfig.  Otherwise, CONFIG_FIRMWARE_EDID
> can be turned on pointlessly for other architectures, and causing
> a bit confusion when doing configs across different architectures.

Sorry, should be 'when doing config comparisons across different architectures'.
