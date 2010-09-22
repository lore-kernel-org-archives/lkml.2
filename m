Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0IVPNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:13:38 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:36601 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0IVPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:13:36 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, just.for.lkml@googlemail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Subject: Early console confusion
Date: Wed, 22 Sep 2010 09:12:44 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
References: <4C7B0578.8090807@kernel.org> <tip-83d9f65bdae6f6b34d75282c6618d3f50846849a@git.kernel.org>
In-Reply-To: <tip-83d9f65bdae6f6b34d75282c6618d3f50846849a@git.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009220912.45360.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can somebody explain the differences between

	earlycon=uart,...
	earlycon=uart8250,...
	earlyprintk=serial,...
	console=uart,...
	console=uart8250,...

I'm not really convinced we need them all, and it's getting a
little confusing.

Bjorn
