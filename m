Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0I3MWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:22:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52779 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0I3MWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gI5NAE4bqGd4II5AOjo7nmIBiQlSig48canAyQFVcTbt4Ho6DyINn/iwrzEzjpUL3Z
         TyiTGzYn/5kN9GNd0MIs9cY8bZPEawKuLKV2DGzN24kkxfVHEpqLuHUcyhjkDPF3t7Ao
         9e5Y6pi357Y7CS4D1o2/LI79oZbli2uMevi70=
Date: Thu, 30 Sep 2010 14:18:39 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] x86, amd: Add basic support for AMD CPU family 15h
Message-ID: <20100930121839.GA20545@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following a bunch of patches with basic adaptions to support AMD CPU
family 15h.

Patches are against tip/master (v2.6.36-rc6-1544-gc5bf3de).
Please apply.


Thanks,

Andreas
