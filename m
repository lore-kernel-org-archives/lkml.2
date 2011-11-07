Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1KGQgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:36:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55409 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1KGQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:36:41 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
Date: Mon, 7 Nov 2011 17:36:39 +0100
Message-ID: <CAFfN3gXdqb7aKF1MiE8XAbu=seTy+9Giqs5SZcMbF2rfoDmX_Q@mail.gmail.com>
Subject: Re: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
From: Hubert Feurstein <h.feurstein@gmail.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry, but your patch still does not apply. You fixed the tab issue,
but it seems that there are still some bad whitespaces left which
corrupt your patch.

Regards
Hubert
