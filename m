Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2D3Obs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:31:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40822 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2D3Obr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:31:47 -0400
MIME-Version: 1.0
Date: Mon, 30 Apr 2012 16:31:46 +0200
Message-ID: <CADDKRnDR=baZtQfyQLxYGB2zVDMGi2C_V2ffNkSUhipJB-+t=A@mail.gmail.com>
Subject: [v3.4-rc5]: drm references experimental
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
there is a dependency between drm and experimental driver. If I
don't enable EXPERIMENTAL I see the following during configuration:

warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct
dependencies (EXPERIMENTAL)

I think non-experimental code shouldn't depend on experimental code.

Jörg

Please Cc me. I'm not subscribed.
