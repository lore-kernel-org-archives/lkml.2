Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0KVBD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:03:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab0KVBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eOTLoefccCPn0RN2VKjIFEP1BYsbPMQ3dfOcjreTKF9QUBtEmfMLyVN1osdX+OhIsu
         ZPBK5D9b19muCFuX8y2eSsGPUaep/dQPTXdsmOhXfi/dOLbZWdM0DFSOGpDSxcg4vMWa
         fanr92yf17T4K8FYQW8jnT4xShLqfkDa6Qaws=
From: Tracey Dent <tdent48227@gmail.com>
To: davem@davemloft.net
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
        urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
        sage@newdream.net, ceph-devel@vger.kernel.org, wang840925@gmail.com,
        jlayton@redhat.com, kaber@trash.net, pekkas@netcore.fi,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, samuel@sortiz.org
Subject: [PATCH 00/00] Remove deprecated items from Makefiles
Date: Sun, 21 Nov 2010 20:03:11 -0500
Message-Id: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed Makefiles to use <modules>-y instead of <modules>-objs because -objs
is deprecated and not even mentioned in Documentation/kbuild/makefiles.txt.

Also, remove some if-conditional statments because I used the ccflags-$ flag 
instead of EXTRA_CFLAGS because EXTRA_CFLAGS.

regards,

Tracey Dent

