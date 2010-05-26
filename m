Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0EZTIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:08:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47528 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0EZTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:08:29 -0400
MIME-Version: 1.0
X-Originating-IP: [174.31.27.127]
Date: Wed, 26 May 2010 12:08:26 -0700
Message-ID: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
Subject: Controlling Driver Load Order
From: Robert Emanuele <rob@emanuele.us>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Hopefully this is an easy question but I haven't found a solution yet.

On my at91sam9g45 platform I need my i2c drivers to load before the
framebuffer driver.  The i2c drivers control a power management IC
which is needed to enable the graphics controller.

Is there a way to set up that order?

Thank you,

Rob Emanuele
