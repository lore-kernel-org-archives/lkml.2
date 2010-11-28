Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0K1K4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 05:56:49 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44536 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0K1K4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 05:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OFkRk6fQY9eDQt2AV3GoOQDpdhl8m/hZ+gtLWuaFibzUmNhQXqOa9zYttV2DDDN7bP
         7p8PDVQ9NONbyPrUfsLzGN6wZEWjMTaP6MlAjTJmzi6+L3O/96edAVK3L8MomDGMkvPV
         9QwRVUPg+c/6j47ELggbWLANDJBV+7gEx0dxQ=
Subject: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Sun, 28 Nov 2010 18:57:55 +0800
Message-ID: <1290941875.13526.15.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, there

	I'm implementing the UNICODE font of the framebuffer console, (see
http://lkml.org/lkml/2010/11/26/50 in case you do not got my email). But
current vt code is too bugy, too many direct assumes about vt buffer,
This makes me so hard to hack.  There is TODO telling me to add UNICODE
support, but no room for such code, that's why my patch is so tricky.

	And the code itself, if you'll excuse me, it isn't as beautiful as rest
of the kernel.
	So, it really really need a clean rewrite.I'm ganna take is hard job.	
	And, please tell me if is worth to do so.


