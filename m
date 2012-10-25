Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab2JYOVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:21:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab2JYOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:21:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH v4] pwm: vt8500: Update vt8500 PWM driver support
Date: Thu, 25 Oct 2012 14:21:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: thierry.reding@avionic-design.de, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1351100330-26072-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1351100330-26072-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251421.44474.arnd@arndb.de>
X-Provags-ID: V02:K0:DH8J868KRV7PBRUB072fytTWXUBAog3njSd2bilnNRi
 qYnTV11vJ6oWnHBzV1Z+vXEDePO8NoJadJzuup6qUB3ZbLIPTe
 ALechv3B9Vq/Zvwr7gv68hrGP4fZHwDfaPBmtUogyN+pcBKS1e
 +s6INsIZpEJRnAvHKeTZ8e5jIh1K6QUw6v2MuB8zPZ9EA6oWPG
 QqTg2VZcBocrm3EwXB5pKcULrY5lU0wdt8IV5DdtClSDLdAk9S
 q3OXalIY2hblFv5o01nJh0rYJzfK7hgvxdfF8WKq9g8YQqIVi6
 Dl9zW77Luv84CReim5P49dK4M8jgmk0G7+vPoYtjiGCeJg2cyu
 QNuBOkQC6QAUBSukqXLA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Tony Prisk wrote:
> This patch updates pwm-vt8500.c to support devicetree probing and
> make use of the common clock subsystem.
> 
> A binding document describing the PWM controller found on
> arch-vt8500 is also included.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Acked-by: Arnd Bergmann <arnd@arndb.de>
