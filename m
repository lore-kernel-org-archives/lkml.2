Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0KKNyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:54:47 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:28428
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412Ab0KKNyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:54:46 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h668h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp02.amd.com;RD:ausb3extmailp02.amd.com;EFVD:NLI
X-WSS-ID: 0LBQ3YF-02-ALP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: Borislav Petkov <bp@amd64.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: [PATCH 0/3] Erratum 383 fix for 32 bit x86 kernels
Date: Thu, 11 Nov 2010 14:56:12 +0100
Message-ID: <1289483775-17632-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101022162038.GA10343@kroah.com>
References: <20101022162038.GA10343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

ok, these are the 3 patches required for the Erratum 383 fix on 32 bit
for the 2.6.32.25 kernel. The patches apply cleanly on-top of it. I
tested the kernel with defconfig and allnoconfig and on 32 and 64 bit.
Every of the 4 combinations comiled fine and booted fine on and UMP and
SMP virtual machine until the point where they wanted to mount a
root-fs.
The problems you had with the previous patches should be solved now.
Sorry for the inconvenience.

Regards,
	Joerg


