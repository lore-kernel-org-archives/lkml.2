Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2FYUVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:21:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37087 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2FYUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:21:49 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Usb Gadget Devicetree override
Date: Mon, 25 Jun 2012 17:21:42 -0300
Message-Id: <1340655704-30398-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is a proposal to enable the devicetree udc node to override the gadget driver information, instead of using module arguments.

Please, let me know if this seems ok. If so, I can repost this as a full patch set including all udc and gadget drivers.

Thanks.

