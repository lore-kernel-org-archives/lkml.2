Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1EZJIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:08:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:52076 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1EZJIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:08:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,272,1304319600"; 
   d="scan'208";a="9183016"
Date: Thu, 26 May 2011 09:55:15 +0100
From: Alan Cox <alan@linux.intel.com>
To: Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial/pch: use global div helper instead of creating a
 private one
Message-ID: <20110526095515.147ec045@bob.linux.org.uk>
In-Reply-To: <1306399277-17094-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1306399277-17094-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 10:41:17 +0200
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Alan Cox  <alan@linux.intel.com>
