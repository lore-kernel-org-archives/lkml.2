Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab1EBLkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 07:40:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53426 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab1EBLka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 07:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=p5SxEEmemkVHRgZOeI/b6OIzYMGLgpcsgZz2waRb7EMtEHhwf/DqKn07I/u14t6t+H
         3V9PX3Pthx3jFFHeTlgd5ueCD1zAohXHhPvlC0wgKvgd7Hki6i5E1UPyA27VdIxpbMFF
         UI8ChpkmS31fNIH1xSzwvdVfu4Y/+kmS+vx6U=
Message-Id: <20110502113445.751391656@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 02 May 2011 15:34:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] x2apic optimization, v4 log updated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Ingo, this series consist of updated commit messages,
so I hope this time I made all things right.

  Please ping me if something still not confirm the submitting
patch guide.

  Suresh, I've putted your ack and tested-by in a sake of consistency
with submitting patch guide.

Thanks,
  Cyrill
