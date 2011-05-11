Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1EKSYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:24:52 -0400
Received: from mx01.bfk.de ([193.227.124.2]:34809 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1EKSYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:24:51 -0400
X-Greylist: delayed 9300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 14:24:51 EDT
From: Florian Weimer <fweimer@bfk.de>
To: David Decotigny <decot@google.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/dl2k: Don't reconfigure link @100Mbps when disabling autoneg @1Gbps
References: <1304986748-15809-1-git-send-email-decot@google.com>
	<1304986748-15809-3-git-send-email-decot@google.com>
Date: Wed, 11 May 2011 09:47:16 +0000
In-Reply-To: <1304986748-15809-3-git-send-email-decot@google.com> (David
	Decotigny's message of "Mon, 9 May 2011 17:19:08 -0700")
Message-ID: <82y62dk1qz.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Decotigny:

> Tested: module compiling, NOT tested on real hardware.

To my knowledge, dl2k is broken.  Some sort of synchronization
primitives are missing.  Under load, the NIC's notion of ring buffer
status diverges from the host's view. 8-(

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
