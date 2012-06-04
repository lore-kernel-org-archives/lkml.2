Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608Ab2FDNbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:31:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53020 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2FDNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:31:17 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Federico Vaga <federico.vaga@gmail.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: generic module for c-can on pci
Date: Mon,  4 Jun 2012 15:32:45 +0200
Message-Id: <1338816766-7089-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <4FC135C6.5030206@grandegger.com>
References: <4FC135C6.5030206@grandegger.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As suggested I developed a generic module for C-CAN
on PCI. Probably I will do some changes about our
specific board, but I think that the module is generic
enough.
