Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2GJMYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:24:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:55286 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2GJMYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:24:40 -0400
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload 
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
Date: Tue, 10 Jul 2012 07:24:30 -0500
Cc: "timur@freescale.com" <timur@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <22C2B39B-2B20-42F6-A5F6-17E437CC14ED@kernel.crashing.org>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
To: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 11, 2011, at 10:05 AM, Kokoris, Ioannis wrote:

> Hi,
> 
> QE Microcode Initialization using qe_upload_microcode() does not work on P1021 if the IRAM-Ready register is not set after the microcode upload. This patch adds a definition for the "I-RAM Ready" register and sets it uppon microcode upload completion.
> 
> 
> Signed-off-by: Ioannis Kokkoris <ioannis.kokoris@siemens-enterprise.com>
> 

applied to next

- k